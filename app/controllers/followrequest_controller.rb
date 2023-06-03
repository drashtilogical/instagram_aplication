class FollowrequestController < ApplicationController
  def accept
    @follow_request = FollowRequest.find(params[:id])
    @follow_request.accepted = true
    if @follow_request.save
      redirect_to @follow_request.follower, notice: 'Follow request accepted.'
    else
      redirect_to @follow_request.follower, alert: 'Failed to accept follow request.'
    end
  end

  def reject
    @follow_request = FollowRequest.find(params[:id])
    if @follow_request.destroy
      redirect_to @follow_request.follower, notice: 'Follow request rejected.'
    else
      redirect_to @follow_request.follower, alert: 'Failed to reject follow request.'
    end
  end
end
