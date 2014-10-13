class ProfilesController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def show
    @user = current_user
    respond_with @user
  end
end
