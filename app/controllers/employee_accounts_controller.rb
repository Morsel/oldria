class EmployeeAccountsController < ApplicationController
  before_filter :require_user
  before_filter :find_and_authorize_restaurant
  
  def create
    result = @restaurant.subscription.add_staff_account(@employee)
    if !result
      flash[:error] = "Whoops. We couldn't process your credit card with the information you provided due to the following reason: <br />PUT IN THE ERROR MESSAGE HERE!! <br /> If you continue to experience issues, <a mail='billing@restaurantintelligenceagency.com'>please contact us.</a>"
    end
    redirect_to edit_restaurant_employee_path(@restaurant, @employee)
  end
  
  def destroy
    result = @restaurant.subscription.remove_staff_account(@employee)
    if !result
      flash[:error] = "Whoops. We couldn't process that account change. If you continue to experience issues, please contact us."
    end
    redirect_to edit_restaurant_employee_path(@restaurant, @employee)
  end
  
  private
  
  def find_and_authorize_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    @employee = @restaurant.employees.find(params[:id]) rescue nil
    unauthorized! if @employee.nil?
    unauthorized! if cannot? :edit, @restaurant
    if !@restaurant.has_braintree_account?
      flash[:error] = "A restaurant must have a Premium Account to add staff members."
      redirect_to edit_restaurant_employee_path(@restaurant, @employee)
    end 
  end
  
end