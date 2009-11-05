class EmployeesController < ApplicationController
  before_filter :require_user
  before_filter :find_restaurant

  def index
    @employees = @restaurant.employees
  end

  def new
    @employment = @restaurant.employments.build(params[:employment])
    find_or_initialize_employee if params[:employment]
  end

  def create
    @employment = @restaurant.employments.build(params[:employment])
    # If the new user isn't valid, halt the whole action
    return unless verify_employee

    if @employment.save
      flash[:notice] = "Successfully associated employee and restaurant"
      redirect_to restaurant_employees_path(@restaurant)
    else
      flash[:error] = "We could not associate that employee with this restaurant. Please try again."
      render :new
    end
  end

  private
  
  def find_or_initialize_employee
    email = params[:employment][:employee_email]
    @employee = User.find_by_email(email)
    if @employee
      render :confirm_employee 
    else
      flash.now[:notice] = "We couldn't find them in our system. You can invite this person."
      @employee = @restaurant.employees.build(:email => email)
      render :new_employee
    end
  end
  
  def verify_employee
    @employee = @employment.employee
    if @employee.new_record? 
      @employee.send_invitation = true
      unless @employee.save
        render :new_employee
        return false
      end
    end
    @employment.employee_id ||= @employee.id
    true
  end
  
  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
