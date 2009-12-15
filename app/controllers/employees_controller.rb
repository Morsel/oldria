class EmployeesController < ApplicationController
  before_filter :require_user
  before_filter :find_and_authorize_restaurant, :except => :index

  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    @employments = @restaurant.employments.all(:include => [:subject_matters, :restaurant_role, :employee])
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
      @employee.deliver_invitation_message! if @send_invitation
      redirect_to restaurant_employees_path(@restaurant)
    else
      flash[:error] = "We could not associate that employee with this restaurant. Please try again."
      render :new
    end
  end

  def edit
    @employment = @restaurant.employments.find_by_employee_id(params[:id])
    @employee = @employment.employee
  end

  def update
    @employment = @restaurant.employments.find_by_employee_id(params[:id])
    if @employment.update_attributes(params[:employment])
      flash[:notice] = "Successfully updated employee"
    else
      flash[:error] = "We were unable to update that employee"
    end
    redirect_to restaurant_employees_path(@restaurant)
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @employment = @restaurant.employments.find_by_employee_id(params[:id])
    employee = @employment.employee

    if @employment.destroy
      flash[:notice] = employee.first_name + ' was removed from ' + @restaurant.name
    else
      flash[:error] = "Something went wrong. Our worker bees will look into it."
    end
    redirect_to restaurant_employees_path(@restaurant)
  end


  private

  def find_or_initialize_employee
    email = params[:employment][:employee_email]
    @employee = User.find_by_email(email) || User.find_all_by_name(email).first
    if !@employee.blank?
      @employment.employee_id = @employee.id
      render :confirm_employee
    else
      flash.now[:notice] = "We couldn't find them in our system. You can invite this person."
      @employee = @restaurant.employees.build(:email => email)
      render :new_employee
    end
  end

  def verify_employee
    return true if @employment.employee_id
    @employee = @employment.employee
    if @employee.new_record?
      @employee.send_invitation = true
      if @employee.save
        @send_invitation = true
      else
        render :new_employee
        return false
      end
    end
    @employment.employee_id ||= @employee.id
    true
  end

  def find_and_authorize_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    unauthorized! if cannot? :edit, @restaurant
  end
end
