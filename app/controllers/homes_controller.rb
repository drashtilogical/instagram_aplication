class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.all
    @receivers = current_user.sent_follow_requests.joins(:receiver)
  end
  
  def show
    @user = User.find(params[:id])
    @pending_requests = @user.pending_follow_requests
  end

  def cancel_request
    @user = User.find(params[:id])
    @follow_request = current_user.sent_follow_requests.find_by(receiver_id: @user.id)
  
    if @follow_request
      @follow_request.destroy
      redirect_to users_path, notice: 'Follow request canceled.'
    else
      redirect_to users_path, notice: 'Follow request not found.'
    end
  end

  def accept_request
    @request = FollowRequest.find(params[:id])
    @sender = @request.sender
  
    if @request.update(status: 'accepted')
      current_user.follower(@sender)
      current_user.following_requests.find_by(sender: @sender).destroy
      redirect_to @sender, notice: 'Follow request accepted.'
    else
      redirect_to @sender, alert: 'Unable to accept follow request.'
    end
  end
  
  def reject_request
    @request = FollowRequest.find(params[:id])
    @sender = @request.sender

    if @request.destroy
      redirect_to @sender, notice: 'Follow request rejected.'
    else
      redirect_to @sender, alert: 'Unable to reject follow request.'
    end
  end

  def follow
    @user = User.find(params[:id])
    if @user.private?
      current_user.sent_follow_requests.create(receiver: @user, status: 'pending')
      redirect_to @user, notice: 'Follow request sent.'
    else
      @user.increment!(:followers_count)
      current_user.following << @user unless current_user.following.include?(@user)
      redirect_to home_path, notice: 'User followed successfully.'
    end
  end
  
  def unfollow
    @user = User.find(params[:id])
    current_user.following.delete(@user)
    @user.decrement!(:followers_count)
    redirect_to @user, notice: 'User unfollowed successfully.'
  end
  
end
