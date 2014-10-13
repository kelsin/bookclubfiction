class StatusesController < ApplicationController
  def show
    @current = Round.current
  end
end
