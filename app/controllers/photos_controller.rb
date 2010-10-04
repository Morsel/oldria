class PhotosController < ApplicationController
  before_filter :find_restaurant

  def index
  end

  def create
    @image = @restaurant.photos.create(params[:image])
    if @image.valid?
      redirect_to restaurant_photos_path(@restaurant)
    else
      @restaurant.photos.reload
      render :action => :index
    end
  end

  def destroy
    @restaurant.photos.delete(Image.find(params[:id]))
    redirect_to restaurant_photos_path(@restaurant)
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
