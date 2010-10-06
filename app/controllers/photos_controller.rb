class PhotosController < ApplicationController
  before_filter :find_restaurant

  def index
  end

  def create
    @photo = @restaurant.photos.create(params[:photo])
    if @photo.valid?
      redirect_to restaurant_photos_path(@restaurant)
    else
      @restaurant.photos.reload
      render :action => :index
    end
  end

  def destroy
    @restaurant.photos.delete(Photo.find(params[:id]))
    redirect_to restaurant_photos_path(@restaurant)
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
