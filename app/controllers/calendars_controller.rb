class CalendarsController < ApplicationController

  before_filter :authenticate_employee
  before_filter :parse_and_assign_date

  def index
    @categories = Event::CATEGORIES
    if params[:category] && (params[:category] != "all")
      @events = @restaurant.events.for_month_of(@date).by_category(params[:category])
    else
      @events = @restaurant.events.for_month_of(@date)
    end
  end

  def ria
    @categories = Event::ADMIN_CATEGORIES
    @events = Event.from_ria
    render :index
  end

  private

  def parse_and_assign_date
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

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
