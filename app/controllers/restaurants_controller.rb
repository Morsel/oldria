class RestaurantsController < ApplicationController
  before_filter :require_user

  def new
    @restaurant = current_user.managed_restaurants.build
  end
  
  def create
    @restaurant = current_user.managed_restaurants.build(params[:restaurant])
    if @restaurant.save
      flash[:notice] = "Successfully created restaurant."
      redirect_to root_url
    else
      render :new
    end
  end
end
