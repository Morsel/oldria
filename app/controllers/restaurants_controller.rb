class RestaurantsController < ApplicationController
  before_filter :require_user
  before_filter :authenticate, :only => [:edit, :update]
  
  def index
    respond_to do |format|
      format.js { autocomplete_restaurants }
    end
  end

  def new
    @restaurant = current_user.managed_restaurants.build
  end

  def show
    find_restaurant
    @employments = @restaurant.employments.all(:include => [:subject_matters, :restaurant_role, :employee])
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

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])    
  end  
  
  def authenticate
    find_restaurant
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end
  
  def autocomplete_restaurants
    @restaurants = Restaurant.find(:all, :conditions => ["name like ?", "%#{params[:q]}%"]) if params[:q]
    if @restaurants
      render :text => @restaurants.map(&:name).join("\n")
    end
  end

end
