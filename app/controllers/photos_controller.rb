# frozen_string_literal: true

# Controller for managing photos.
class PhotosController < ApplicationController
  def index
    @public_users = User.where(private: false)
    @public_photos = Photo.where(user: @public_users)
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    if @photo.save
      redirect_to photos_path, notice: 'Photo was successfully uploaded.'
    else
      render :new
    end
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def like
    @photo = Photo.find(params[:id])
    current_user.likes.create(photo: @photo) unless current_user.likes.exists?(photo: @photo)
    @photo.increment!(:like_count)
    redirect_to @photo, notice: 'Photo liked successfully.'
  end

  def unlike
    @photo = Photo.find(params[:id])
    like = current_user.likes.find_by(photo: @photo)
    like.destroy if like.present?
    @photo.decrement!(:like_count)
    redirect_to @photo, notice: 'Photo unliked successfully.'
  end

  private

  def photo_params
    params.require(:photo).permit(:caption, :image)
  end
end
