class EventsController < CalendarsController

  def new
    @event = Event.new
  end
  
  def create
    @event = @restaurant.events.build(params[:event])
    if @event.save
      redirect_to restaurant_calendars_path(@restaurant)
    else
      render :action => "new"
    end
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
end
