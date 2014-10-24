class NominationsController < ApplicationController
  load_and_authorize_resource :round
  load_and_authorize_resource :through => :round

  before_action :is_round_seconding?, :only => [:vote, :unvote, :extra, :unextra]
  after_action :update_faye, :only => [:vote, :unvote, :extra, :unextra]

  LOCK_TIME = 5.minutes

  def create
    @nomination.user = current_user
    @nomination.round = @round

    @nomination.votes = [{ :id => current_user.id,
                           :created_at => Time.now }] unless @nomination.admin?

    begin
      @nomination.save! :safe => true

      # Now remove any selections for the same book
      Selection
        .by_round(@nomination.round_id)
        .by_user(@nomination.user_id)
        .destroy_all('book.goodreads_id' => @nomination.book.goodreads_id)

    rescue Mongo::OperationFailure => e
      raise Exceptions::DuplicateNomination, 'This book is already nominated'
    end
  end

  def vote
    Nomination.push({ :id => params[:id],
                      'votes.id' => { :$ne => current_user.id } },
                    :votes => { :id => current_user.id,
                                :created_at => Time.now },
                    :safe => true)
    @nomination.reload
  end

  def unvote
    @nomination.pull(:votes => { :id => current_user.id,
                                 :created_at => { :$gt => LOCK_TIME.ago.utc } },
                     :safe => true)
    @nomination.reload

    # Removing a vote should remove the extra as well
    unextra
  end

  def extra
    # We should only allow this if you have a vote
    raise Exceptions::ExtraVotesError, "You do not have enough extra votes" unless current_user.extra_votes > 0

    vote

    result = Nomination.push({ :id => params[:id],
                               'extras.id' => { :$ne => current_user.id } },
                             :extras => { :id => current_user.id,
                                         :created_at => Time.now },
                             :safe => true)

    if result['nModified'] > 0
      current_user.decrement(:extra_votes => result['nModified'])
      current_user.reload
    end

    @nomination.reload
  end

  def unextra
    time = LOCK_TIME.ago.utc
    result = Nomination.pull({ :id => params[:id],
                               'extras.created_at' => { :$gt => time } },
                             { :extras => { :id => current_user.id,
                                            :created_at => { :$gt => time } } },
                             :safe => true)

    if result['nModified'] > 0
      current_user.increment(:extra_votes => result['nModified'])
      current_user.reload
    end

    @nomination.reload
  end

  def win
    @nomination.winner = true
    @nomination.save
  end

  def unwin
    @nomination.winner = false
    @nomination.save
  end

  private

  def update_faye
    @nomination.reload

    EM.run {
      client = Faye::Client.new(Rails.env.production? ? 'https://www.bookclubfiction.net/faye' : 'http://localhost:3000/faye')
      client.publish('/votes',
                     JSON.parse(render_to_string(:template => 'nominations/votes.json.jbuilder')))
    }
  end

  def is_round_seconding?
    raise Exceptions::RoundStateError, "Round is not currently seconding" unless @round.seconding?
  end
end
