class NominationsController < ApplicationController
  load_and_authorize_resource :round
  load_and_authorize_resource :through => :round

  before_action :is_round_seconding?, :only => [:vote, :unvote, :extra, :unextra]
  after_action :update_faye, :only => [:vote, :unvote, :extra, :unextra]

  def create
    @nomination.user = current_user
    @nomination.round = @round

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
    @nomination.add_to_set(:vote_user_ids => current_user.id, :safe => true)
    @round.reload
  end

  def unvote
    @nomination.pull(:vote_user_ids => current_user.id, :safe => true)
    @round.reload

    # Removing a vote should remove the extra as well
    unextra
  end

  def extra
    # We should only allow this if you have a vote
    raise Exceptions::ExtraVotesError, "You do not have enough extra votes" unless current_user.extra_votes > 0

    vote

    result = @nomination.add_to_set(:extra_user_ids => current_user.id, :safe => true)

    if result['nModified'] > 0
      current_user.decrement(:extra_votes => result['nModified'])
      current_user.reload
    end

    @round.reload
  end

  def unextra
    result = @nomination.pull(:extra_user_ids => current_user.id, :safe => true)

    if result['nModified'] > 0
      current_user.increment(:extra_votes => result['nModified'])
      current_user.reload
    end

    @round.reload
  end

  private

  def update_faye
    @nomination.reload

    EM.run {
      client = Faye::Client.new(Rails.env.production? ? 'http://www.bookclubfiction.net:9292/faye' : 'http://localhost:3000/faye')
      client.publish('/nominations',
                     { :id => @nomination.id,
                       :value => @nomination.value,
                       :votes => @nomination.vote_user_ids.size,
                       :extras => @nomination.extra_user_ids.size })
    }
  end

  def is_round_seconding?
    raise Exceptions::RoundStateError, "Round is not currently seconding" unless @round.seconding?
  end
end
