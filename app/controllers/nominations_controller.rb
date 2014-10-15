class NominationsController < ApplicationController
  load_and_authorize_resource

  def create
    @nomination.save! :safe => true
  end
end
