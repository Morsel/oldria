class RestaurantsController < ApplicationController
  before_filter :require_user
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :find_restaurant, :only => [:upload_logo, :select_primary_photo]

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
    @restaurant.media_contact = current_user
    if @restaurant.save
      flash[:notice] = "Successfully created restaurant."
      redirect_to restaurant_employees_path(@restaurant)
    else
      render :new
    end
  end

  def upload_logo
    @restaurant.logo = Image.new(params[:logo])
    if @restaurant.save
      redirect_to edit_restaurant_path(@restaurant)
    else
      render :action => :edit
    end
  end

  def select_primary_photo
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to restaurant_photos_path(@restaurant)
    else
      flash[:error] = "We were unable to update the restaurant"
      render :template => "photos/edit"
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

end
