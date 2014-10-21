class UsersController < ApplicationController
  def index
    authorize! :read, User
    @users = User.all
  end

  def vote
    authorize! :vote, User
    User.increment({ :id => params[:id] },
                   :extra_votes => 1)
    @user = User.where(:id => params[:id]).first
  end

  def unvote
    authorize! :unvote, User
    User.decrement({ :id => params[:id],
                     :extra_votes.gt => 0},
                   :extra_votes => 1)
    @user = User.where(:id => params[:id]).first
  end
end
