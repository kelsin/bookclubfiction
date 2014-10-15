class SelectionsController < ApplicationController
  load_and_authorize_resource :round
  load_and_authorize_resource

  def create
    @selection.user = current_user
    @selection.round = @round

    begin
      @selection.save! :safe => true
    rescue Mongo::OperationFailure => e
      raise Exceptions::DuplicateNomination, 'This book is already selected'
    end
  end
end
