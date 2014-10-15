class VotesController < ApplicationController
  load_and_authorize_resource

  def create
    @vote.save!
  end
end
