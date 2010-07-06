class EventsController < CalendarsController

  def new
    @event = Event.new
  end
  
  def create
    @event = @restaurant.events.build(params[:event])
    if @event.save
      flash[:notice] = "Created #{@event.title}"
      redirect_to restaurant_calendars_path(@restaurant)
    else
      render :action => "new"
    end
  end
  
  def show
    find_event
  end
  
  def edit
    find_event
  end
  
  def update
    find_event
    if @event.update_attributes(params[:event])
      flash[:notice] = "Updated #{@event.title}"
      redirect_to restaurant_calendars_path(@restaurant)
    else
      render :action => :edit
    end
  end
  
  def destroy
    find_event
    flash[:notice] = "Deleted #{@event.title}"
    @event.destroy
    redirect_to restaurant_calendars_path(@restaurant)
  end
  
  private
  
  def find_event
    @event = Event.find(params[:id])
  end
  
end
