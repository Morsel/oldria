class EmployeesController < ApplicationController
  before_filter :require_user
  before_filter :find_restaurant

  def index
    @employees = @restaurant.employees
  end

  def new
    @employment = @restaurant.employments.build
  end

  def create
    @employment = @restaurant.employments.build(params[:employment])
    if @employment.save
      flash[:notice] = "Successfully associated employee and restaurant"
      redirect_to restaurant_employees_path(@restaurant)
    else
      flash.now[:error] = "We could not associate that employee with this restaurant"
      render :new
    end
  end

  private
  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
