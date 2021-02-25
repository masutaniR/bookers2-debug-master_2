class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    @user.create_notification_follow(current_user)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
  end
end
