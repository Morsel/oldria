class EventsController < CalendarsController

  def new
    @event = Event.new
    @event.attachments.build
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
    @event.attachments.build if @event.attachments.blank?
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
  
  def ria_details
    find_event
  end
  
  def transfer
    find_event
    new_event = Event.new(@event.attributes)
    new_event.category = @event.calendar
    new_event.parent_id = @event.id
    new_event.restaurant = @restaurant
    if new_event.save
      flash[:notice] = "Added #{new_event.title} to your calendar"
      redirect_to restaurant_calendars_path(@restaurant)
    else
      flash[:error] = "We are unable to save your event."
      redirect_to :action => "ria_details", :id => @event, :restaurant_id => @restaurant
    end
  end
  
  private
  
  def find_event
    @event = Event.find(params[:id])
  end
  
end
