class HomesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @pending_requests = Following.where(followed_user: @user, status: 'pending').includes(:follower)
    @photos = @user.photos
    @follower_count = Following.where(followed_user_id: @user.id, status: 'accepted').count
    @following_count = Following.where(follower_id: @user.id, status: 'accepted').count
    if !user_signed_in?
      redirect_to new_user_session_path, notice: 'Please sign in to view details.'
    elsif current_user == @user || current_user.followings.exists?(followed_user_id: @user.id) || !@user.private?
      render 'show'
    else
      redirect_to root_path, alert: "You're not authorized to view this user's details."
    end
  end

  def like_photo
    @user = User.find(params[:id])
    @liked_photos = Photo.joins(:likes).where(likes: { user_id: @user.id })
  end

  def send_request
    @user = User.find(params[:id])
    if @user.private?
      following = current_user.followings.build(followed_user: @user, follower_id: current_user.id, status: 'pending')
      if following.save
        redirect_to @user, notice: 'Follow request sent.'
      else
        redirect_to @user, alert: 'Failed to send follow request.'
      end
    else
      following = current_user.followings.build(followed_user: @user, status: 'accepted')
      if following.save
        redirect_to home_path, notice: 'You are now following .'
      else
        redirect_to home_path(@user), alert: 'Failed to follow .'
      end
    end
  end

  def cancel_request
    followed_user = User.find(params[:id])
    following = current_user.followings.find_by(followed_user: followed_user, status: 'pending')
    if following
      following.destroy
      redirect_to user_path(followed_user), notice: "Follow request canceled for #{followed_user.username}."
    else
      redirect_to user_path(followed_user), alert: "No pending follow request found for #{followed_user.username}."
    end
  end

  def accept_request
    follower = User.find(params[:id])
    following = follower.followings.find_by(followed_user: current_user, status: 'pending')
    if following
      following.update(status: 'accepted')
      redirect_to user_path(current_user), notice: "You have accepted the follow request from #{follower.username}."
    else
      redirect_to user_path(current_user), alert: "No pending follow request found from #{follower.username}."
    end
  end

  def reject_request
    follower = User.find(params[:id])
    following = follower.followings.find_by(followed_user: current_user, status: 'pending')
    if following
      following.destroy
      redirect_to user_path(current_user), notice: "You have rejected the follow request from #{follower.username}."
    else
      redirect_to user_path(current_user), alert: "No pending follow request found from #{follower.username}."
    end
  end

  def unfollow
    followed_user = User.find(params[:id])
    following = current_user.followings.find_by(followed_user_id: followed_user.id, status: 'accepted')
    if following
      following.destroy
      redirect_to user_path(followed_user), notice: "You have unfollowed #{followed_user.username}."
    else
      redirect_to user_path(followed_user), alert: "You were not following #{followed_user.username}."
    end
  end
end
