class CalendarsController < RestaurantsController
  
  before_filter :find_restaurant
  
  def index
    @events = @restaurant.events
  end
  
  def new_event
    @event = Event.new
  end
  
  def create_event
    @event = @restaurant.events.create(params[:event])
    redirect_to :action => "index"
  end
  
  protected
  
  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])    
  end
  
end
