class HomesController < ApplicationController
  def index
    @users = User.all
    @follow_request_sent_users = current_user.sent_follow_requests.map(&:receiver) if user_signed_in?
  end

  def show
    @user = User.find(params[:id])
    @followers_count = @user.followers.count
    @following_count = @user.following_count
  
  
    
    if current_user.sent_follow_requests.exists?(receiver: @user)
      @follow_request_status = 'pending'
      @follow_request = current_user.sent_follow_requests.find_by(receiver: @user)
      @follower_name = @follow_request.sender.username
    elsif current_user.following.include?(@user)
      @follow_request_status = 'following'
    elsif @user.private?
      @follow_request_status = 'not_following'
    else
      @follow_request_status = 'public_account'
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

  def cancel_request
    @user = User.find(params[:id])
    request = current_user.sent_follow_requests.find_by(receiver: @user)
    request.destroy if request
    redirect_to @user, notice: 'Follow request canceled.'
  end
  

  def accept_request
    @user = User.find(params[:id])
    request = current_user.pending_follow_requests.find_by(sender: @user)
    request.update(status: 'accepted') if request
    redirect_to @user, notice: 'Follow request accepted.'
  end

  def reject_request
    @user = User.find(params[:id])
    request = current_user.pending_follow_requests.find_by(sender: @user)
    request.destroy if request
    redirect_to @user, notice: 'Follow request rejected.'
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.following.delete(@user)
    @user.decrement!(:followers_count)
    redirect_to @user, notice: 'User unfollowed successfully.'
  end
  
end

