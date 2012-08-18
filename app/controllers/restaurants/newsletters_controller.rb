class Restaurants::NewslettersController < ApplicationController

  before_filter :authorize

  def index
  end

  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Updated newsletter settings"
      redirect_to :action => "index", :restaurant => @restaurant
    end
  end

  private

  def authorize
    @restaurant = Restaurant.find(params[:restaurant_id])
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end

end
