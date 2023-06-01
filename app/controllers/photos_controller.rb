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

  # ...

  private

  def photo_params
    params.require(:photo).permit(:caption, :image)
  end
end
