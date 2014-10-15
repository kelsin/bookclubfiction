class SelectionsController < ApplicationController
  load_and_authorize_resource :round
  load_and_authorize_resource

  skip_authorize_resource :round, :only => :destroy

  def create
    @selection.user = current_user
    @selection.round = @round

    begin
      @selection.save! :safe => true
    rescue Mongo::OperationFailure => e
      raise Exceptions::DuplicateNomination, 'This book is already selected'
    end
  end

  def destroy
    # We can only delete a section while the round is nominating
    raise Exceptions::RoundStateError, 'This round is not currently nominating' unless @round.nominating?

    begin
      @selection.destroy
    rescue Mongo::OperationFailure => e
      raise Exceptions::DuplicateNomination, 'This book is already removed'
    end
  end
end
