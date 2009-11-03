class EmployeesController < ApplicationController
  before_filter :find_restaurant, :except => :index

  def index
    respond_to do |format|
      format.html do 
        find_restaurant
        @employees = @restaurant.employees
      end
      format.js { auto_complete_employees }
    end
  end

  def new
    @employee = @restaurant.employees.build
  end

  def create
    @employee = User.find_by_name(params[:employee][:name])
    if @employee && @restaurant.employees << @employee
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
  
  protected
  def auto_complete_employees
    @employees = User.for_autocomplete.find_all_by_name(params[:q]) if params[:q]
    if @employees
      render :text => @employees.map(&:name).join("\n")
    end
  end
end
