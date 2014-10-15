class UsersController < ApplicationController
  def vote
    authorize! :vote, User
    User.increment({ :id => params[:id] },
                   :extra_votes => 1)
    @user = User.where(:user_id => params[:id]).first
  end

  def unvote
    authorize! :unvote, User
    User.decrement({ :id => params[:id],
                     :extra_votes.gt => 0},
                   :extra_votes => 1)
    @user = User.where(:user_id => params[:id]).first
  end
end
