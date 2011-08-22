class RestaurantsController < ApplicationController
  before_filter :require_user
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :find_restaurant, :only => [:show, :select_primary_photo, :new_manager_needed, :replace_manager]

  def index
    @employments = current_user.employments
  end

  def new
    @restaurant = current_user.managed_restaurants.build
  end

  def create
    @restaurant = current_user.managed_restaurants.build(params[:restaurant])
    @restaurant.media_contact = current_user
    @restaurant.sort_name = params[:restaurant][:name]
    if @restaurant.save
      flash[:notice] = "Successfully created restaurant."
      redirect_to bulk_edit_restaurant_employees_path(@restaurant)
    else
      render :new
    end
  end

  def show
    @employments = @restaurant.employments.by_position.all(
        :include => [:subject_matters, :restaurant_role, :employee])
    @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
    @promotions = @restaurant.promotions.recently_posted.all(:limit => 3)
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

  def select_primary_photo
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to bulk_edit_restaurant_photos_path(@restaurant)
    else
      flash[:error] = "We were unable to update the restaurant"
      render :template => "photos/edit"
    end
  end

  def new_manager_needed
  end

  def replace_manager
    old_manager = @restaurant.manager
    old_manager_employment = @restaurant.employments.find_by_employee_id(@restaurant.manager_id)
    new_manager = User.find(params[:manager])

    if @restaurant.update_attribute(:manager_id, new_manager.id) && old_manager_employment.destroy
      flash[:notice] = "Updated account manager to #{new_manager.name}. #{old_manager.name} is no longer an employee."
    else
      flash[:error] = "Something went wrong. Our worker bees will look into it."
    end

    redirect_to bulk_edit_restaurant_employees_path(@restaurant)
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
