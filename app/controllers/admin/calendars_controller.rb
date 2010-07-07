class Admin::CalendarsController < ApplicationController
  
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    if params[:category] && (params[:category] != "all")
      @events = Event.for_month_of(@date).by_category(params[:category])
    else
      @events = Event.for_month_of(@date).from_ria
    end  
  end
  
end
