class EmploymentsController < ApplicationController
  before_filter :require_user
  before_filter :find_and_authorize_restaurant, :except => :index

  def update
    @employment = @restaurant.employments.find(params[:id])
    @employment.update_attributes(params[:employment])
    redirect_to bulk_edit_restaurant_employees_path(@restaurant)
  end

  def reorder
    params[:employment].each_with_index do |employment_id, index|
      @restaurant.employments.find(employment_id).update_attribute(:position, index + 1)
    end
    render :text => ""
  end

  private

  def find_and_authorize_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    unauthorized! if cannot? :edit, @restaurant
  end
end