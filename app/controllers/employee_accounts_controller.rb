class EmployeeAccountsController < ApplicationController
  before_filter :require_user
  before_filter :find_and_authorize_restaurant
  
  def create
    redirect_to edit_restaurant_employee_path(@restaurant, @employee)
  end
  
  private
  
  def find_and_authorize_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    @employment = @restaurant.employments.find_by_employee_id(params[:id])
    @employee = @employement.employee
    unauthorized! if @employee.nil?
    unauthorized! if cannot? :edit, @restaurant
  end
  
end