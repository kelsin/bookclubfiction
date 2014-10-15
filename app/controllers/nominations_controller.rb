class NominationsController < ApplicationController
  load_and_authorize_resource :round
  load_and_authorize_resource :through => :round

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
    @nomination.pull(:votes => { :user_id => current_user.id }, :safe => true)
    @nomination.reload

    @vote = Vote.new(:user_id => current_user.id)
    @vote.extra = params[:extra]
    @nomination.votes.push(@vote)
    @nomination.save! :safe => true
  end

  def unvote
    @nomination.pull(:votes => { :user_id => current_user.id }, :safe => true)
    @nomination.reload
  end
end
