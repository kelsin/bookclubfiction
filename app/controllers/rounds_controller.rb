class RoundsController < ApplicationController
  load_and_authorize_resource

  def create
    @round.save!
  end

  def show
  end

  def progress
    raise MongoMapper::DocumentNotFound unless @round

    @round.progress

    if @round.changed?
      @round.save

      if @round.reading?
        # Let's mark votes of users down based on nominations
        @round.nominations.each do |nomination|
          nomination.votes.each do |vote|
            User.decrement({ :id => vote.user_id,
                             :extra_votes.gt => 0},
                           :extra_votes => 1) if vote.extra?
          end
        end
      end
    end
  end
end
