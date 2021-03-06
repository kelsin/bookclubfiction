class RoundsController < ApplicationController
  load_and_authorize_resource

  def create
    @round.save!
  end

  def show
  end

  def destroy
    @round.destroy
  end

  def progress
    raise MongoMapper::DocumentNotFound unless @round

    @round.progress
    @round.save if @round.changed?
  end

  def backup
    raise MongoMapper::DocumentNotFound unless @round

    @round.backup
    @round.save if @round.changed?
  end
end
