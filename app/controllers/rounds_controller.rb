class RoundsController < ApplicationController
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource

  def create
    @round = Round.create
  end
end
