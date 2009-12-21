class RestaurantsController < ApplicationController
  before_filter :require_user
  before_filter :authenticate, :only => [:edit, :update]

  def new
    @restaurant = current_user.managed_restaurants.build
  end
  
  def show
    @restaurant = Restaurant.find(params[:id])
  end
  
  def edit
  end
  
  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to @restaurant
    else
      flash[:error] = "We were unable to update the restaurant"
      render :edit
    end
  end
  
  def create
    @restaurant = current_user.managed_restaurants.build(params[:restaurant])
    if @restaurant.save
      flash[:notice] = "Successfully created restaurant."
      redirect_to restaurant_employees_path(@restaurant)
    else
      render :new
    end
  end
  
  private
  
  def authenticate
    @restaurant = Restaurant.find(params[:id])
    if current_user != @restaurant.manager
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end
end
