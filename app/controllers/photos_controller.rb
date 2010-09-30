class PhotosController < ApplicationController
  def destroy
    restaurant = Restaurant.find(params[:restaurant_id])
    restaurant.photos.delete(Image.find(params[:id]))
    redirect_to edit_photos_restaurant_path(restaurant)
  end
end
