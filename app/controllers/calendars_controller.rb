class CalendarsController < RestaurantsController
  
  before_filter :find_restaurant
  
  def index
    @events = @restaurant.events
  end
  
  def new_event
    @event = Event.new
  end
  
  def create_event
    @event = @restaurant.events.build(params[:event])
    if @event.save
      redirect_to :action => "index"
    else
      render :action => "new_event"
    end
  end
  
  protected
  
  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])    
  end
  
end
