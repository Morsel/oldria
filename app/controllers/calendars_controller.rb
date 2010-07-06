class CalendarsController < ApplicationController
  
  before_filter :authenticate_employee
  
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    if params[:category] && (params[:category] != "all")
      @events = @restaurant.events.for_month_of(@date).by_category(params[:category])
    else
      @events = @restaurant.events.for_month_of(@date)
    end
  end
  
  private
  
  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])    
  end  
  
  def authenticate_employee
    find_restaurant
    unless current_user.restaurants.include?(@restaurant) || current_user.admin?
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end
  
end
