class Admin::CalendarsController < Admin::AdminController

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @categories = Event::ADMIN_CATEGORIES
    if params[:category] && (params[:category] != "all")
      @events = Event.for_month_of(@date).by_category(params[:category])
    else
      @events = Event.for_month_of(@date).from_ria
    end
    @events = Event.all if @events.blank?
    render :template  => 'calendars/index'
  end

end
