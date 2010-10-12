class LogosController < ApplicationController
  def destroy
    restaurant = Restaurant.find(params[:restaurant_id])
    restaurant.logo.destroy
    redirect_to edit_restaurant_path(restaurant) 
  end
end