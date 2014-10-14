class StatusesController < ApplicationController
  skip_authorization_check

  def show
    @current = Round.current
  end
end
