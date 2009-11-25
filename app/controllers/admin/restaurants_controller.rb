class Admin::RestaurantsController < Admin::AdminController
  before_filter :find_restaurant, :except => :index

  def index
    @restaurants = Restaurant.find(:all, :include => [:manager, :cuisine])
  end

  def edit
  end

  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to admin_restaurants_path
    else
      flash[:error] = "We were unable to update the restaurant"
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    flash[:notice] = "Successfully removed restaurant"
    redirect_to admin_restaurants_path
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
