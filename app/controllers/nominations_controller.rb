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
end
