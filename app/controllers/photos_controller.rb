class PhotosController < ApplicationController
  before_filter :require_user
  before_filter :require_account_manager_authorization
  before_filter :find_restaurant

  def index
    @photos = @restaurant.photos
  end

  def create
    @photo = @restaurant.photos.create(params[:photo])
    if @photo.valid?
      redirect_to restaurant_photos_path(@restaurant)
    else
      @photos = @restaurant.photos.reload
      render :action => :index
    end
  end

  def destroy
    @restaurant.photos.delete(Photo.find(params[:id]))
    redirect_to restaurant_photos_path(@restaurant)
  end

  def reorder
    params[:photo].each_with_index do |photo_id, index|
      @restaurant.photos.find(photo_id).update_attribute(:position, index + 1)
    end
    render :nothing => true
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id], :include => :photos)
  end
end
