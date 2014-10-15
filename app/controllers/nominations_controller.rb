class NominationsController < ApplicationController
  load_and_authorize_resource :round
  load_and_authorize_resource :through => :round

  def create
    @nomination.user = current_user
    @nomination.round = @round

    begin
      @nomination.save! :safe => true
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
