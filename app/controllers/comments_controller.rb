# frozen_string_literal: true

# Top-level documentation comment for CommentsController
class CommentsController < ApplicationController
  def create
    @photo = Photo.find(params[:photo_id])
    @comment = @photo.comments.build(comment_params)
    @comment.user = current_user # Assuming you have user authentication implemented

    if @comment.save
      redirect_to @photo, notice: 'Comment added successfully.'
    else
      redirect_to @photo, alert: 'Error adding comment.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
