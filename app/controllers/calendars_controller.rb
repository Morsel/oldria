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
    
    if params[:show_ria] && !params[:show_ria].blank?
      if params[:show_ria].match(/Location/)
        @events += Event.from_ria.for_location(params[:show_ria].split(": ")[1]).for_month_of(@date)
      elsif params[:show_ria] == "in my calendar"
        @events += @restaurant.events.for_month_of(@date).map { |e| e.parent }.compact
      else
        @events += Event.from_ria.for_month_of(@date)
      end
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
