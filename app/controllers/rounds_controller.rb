class RoundsController < ApplicationController
  load_and_authorize_resource

  def create
    @round.save!
  end

  def show
  end
end
