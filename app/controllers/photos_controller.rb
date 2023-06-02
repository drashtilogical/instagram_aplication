class PhotosController < ApplicationController
  def new
    @photo = Photo.new
  end

  def index
    @public_photos = Photo.all
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
    like.destroy if like
    @photo.decrement!(:like_count)
    redirect_to @photo, notice: 'Photo unliked successfully.'
  end

  private

  def photo_params
    params.require(:photo).permit(:caption, :image)
  end
end
