class EmployeesController < ApplicationController
  before_filter :require_user
  before_filter :find_and_authorize_restaurant, :except => :index
  before_filter :require_email, :only => :new

  def bulk_edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @employments = @restaurant.employments.by_position.all(
        :include => [:subject_matters, :restaurant_role, :employee])
  end

  def new    
    @employment = @restaurant.employments.build(params[:employment])
    find_or_initialize_employee if params[:employment]
  end

  def create    
    @employment = @restaurant.employments.build(params[:employment])
    # If the new user isn't valid, halt the whole action
    return unless verify_employee
    # FIXME - preventing duplicate employments should happen on the model
    return if employment_duplicated? 

    if @employment.save
      @employment.insert_at
      @employment.employee.default_employment.try(:destroy) # Get rid of user-set employment details
      flash[:notice] = @send_invitation ? "#{@employment.employee.name_or_username} has been sent an invitation and added to your restaurant.<br/>
          Please remind your employee to check their email for instructions on confirming their new account." : 
          "Successfully added #{@employment.employee.name} to this restaurant"
      redirect_to edit_restaurant_employee_path(@restaurant, @employment.employee)
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
      redirect_to bulk_edit_restaurant_employees_path(@restaurant)
    else
      @employee = @employment.employee
      flash[:error] = "We were unable to update that employee"
      render :action => "edit"
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @employment = @restaurant.employments.find_by_employee_id(params[:id])
    employee = @employment.employee

    if employee == @restaurant.media_contact
      redirect_to new_media_contact_restaurant_path(@restaurant) and return
    end
    
    if employee == @restaurant.manager
      redirect_to new_manager_needed_restaurant_path(@restaurant) and return
    end


    if @employment.destroy
      flash[:notice] = employee.name_or_username + ' was removed from ' + @restaurant.name
    else
      flash[:error] = "Something went wrong. Our worker bees will look into it."
    end
    redirect_to bulk_edit_restaurant_employees_path(@restaurant)
  end

  private

  def find_or_initialize_employee
    email = params[:employment][:employee_email]
    @employees = (User.find_all_by_email(email) + User.find_all_by_name(email) + User.find_all_by_first_name(email.split(" ").first) + User.find_all_by_last_name(email.split(" ").last)).uniq.compact

    if @employees.present?
      @employment.employee_id = @employees.first.id
      render :confirm_employee
    else
      identifier = email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) ?
        { :email => email } : 
        { :first_name => email.split(" ").first, :last_name => email.split(" ").last }

      if current_user.admin?
        flash.now[:notice] = "We couldn't find them in our system. You can add this person."
        @employee = @restaurant.employees.build(identifier)
        render :new_employee
      else
        flash[:notice] = "We couldn't find them in our system. You can invite this person."
        redirect_to recommend_invitations_path(:emails => email)
      end
    end
  end

  def verify_employee
    return true if @employment.employee_id
    @employee = @employment.employee
    if @employee.new_record?
      @employee.password_confirmation = @employee.password = Authlogic::Random.friendly_token
      @employee.send_invitation = true
      @employee.invitation_sender = current_user
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

  # FIXME - not the right way to resolve the failing test
  # For passing cucumber features/restaurants/adding_employees.feature:40
  #
  # check if employment already exist in restaurant.
  # after build from params we get duplicate employment.
  # to prevent duplicate - look for 2 employment 
  # with same employee 
  def employment_duplicated?
    employments = @restaurant.employments.select { | employment | employment.employee == @employment.employee }
    if employments.size > 1
      flash[:error] = "Employee is already associated with that restaurant"
      render :new
    else
      return false
    end
  end
  def require_email        
      if !params[:employment].nil? &&  params[:employment][:employee_email].blank?
        flash[:notice] = "Please enter some value."        
        redirect_to :new_restaurant_employee 
      end
  end
end
