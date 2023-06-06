class HomesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @users = User.all
  end

  def show
    if !user_signed_in?
      redirect_to new_user_session_path, notice: 'Please sign in to view details.'
    else
      @user=User.find(params[:id])
      @pending_requests = Following.where(followed_user: @user, status: 'pending').includes(:follower)
      @photos = @user.photos
    end
  end


  def send_request
    @user = User.find(params[:id])
    if @user.private?
      following = current_user.followings.build(followed_user: @user, follower_id: current_user.id, status: "pending")
      redirect_to @user, notice: 'Follow request sent.'
    else
      @user.increment!(:followers_count)
      following = current_user.followings.build(followed_user: @user, follower_id: current_user.id, status: "accepted")
      redirect_to home_path, notice: 'User followed successfully.'
    end
  end

  def cancel_request
    followed_user = User.find(params[:id])
    following = current_user.followings.find_by(followed_user: followed_user, status: "pending")
    if following
      following.destroy
      redirect_to user_path(followed_user), notice: "Follow request canceled for #{followed_user.username}."
    else
      redirect_to user_path(followed_user), alert: "No pending follow request found for #{followed_user.username}."
    end
  end

  def accept_request
    follower = User.find(params[:id])
    following = follower.followings.find_by(followed_user: current_user, status: "pending")
    if following
      following.update(status: "accepted")
      redirect_to user_path(current_user), notice: "You have accepted the follow request from #{follower.username}."
    else
      redirect_to user_path(current_user), alert: "No pending follow request found from #{follower.username}."
    end
  end

  def reject_request
    follower = User.find(params[:id])
    following = follower.followings.find_by(followed_user: current_user, status: "pending")
    if following
      following.destroy
      redirect_to user_path(current_user), notice: "You have rejected the follow request from #{follower.username}."
    else
      redirect_to user_path(current_user), alert: "No pending follow request found from #{follower.username}."
    end
  end

  def unfollow
    followed_user = User.find(params[:id])
    following = current_user.followings.find_by(followed_user: followed_user)
    followed_user.decrement!(:followers_count)
    if following
      following.destroy
      redirect_to user_path(followed_user), notice: "You have unfollowed #{followed_user.username}."
    else
      redirect_to user_path(followed_user), alert: "You were not following #{followed_user.username}."
    end
  end
  
end
