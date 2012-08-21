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

  def preview
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
    @restaurant_answers = @restaurant.restaurant_answers.all(:order => "created_at DESC", :limit => 3)
    @menus = @restaurant.menus.all(:order => "updated_at DESC", :limit => 3)
    @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 3)
    @alaminute_answers = @restaurant.a_la_minute_answers.all(:order => "created_at DESC", :limit => 3)
    render :layout => false
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
