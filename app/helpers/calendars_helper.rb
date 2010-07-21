module CalendarsHelper

  def event_link(event)
    if admin_calendars?
      admin_event_path(event)
    elsif @restaurant && ria_events?
      ria_details_restaurant_event_path(:restaurant_id => @restaurant.id, :id => event.id)
    elsif @restaurant
      restaurant_event_path(:restaurant_id => @restaurant.id, :id => event.id)
    end
  end
  
  def event_link_class(event)
    if ria_events? && @restaurant
      "accepted_#{event.accepted_for_restaurant?(@restaurant)}"
    else
      event.status
    end
  end
  
  def event_link_title(event)
    if ria_events? && @restaurant
      event.accepted_for_restaurant?(@restaurant) ? 
          "#{@restaurant.name} is already participating in this event" : 
          event.description
    else
      event.description
    end
  end

  def restaurant_calendar_link(restaurant, date = nil)
    if restaurant && ria_events?
      params[:category] ? 
          ria_restaurant_calendars_path(:restaurant_id => restaurant, :date => date.try(:to_s), :category => params[:category]) : 
          ria_restaurant_calendars_path(:restaurant_id => restaurant, :date => date.try(:to_s))
    elsif restaurant
      params[:category] ? 
        restaurant_calendars_path(:restaurant_id => restaurant, :date => date.try(:to_s), :category => params[:category]) :
        restaurant_calendars_path(:restaurant_id => restaurant, :date => date.try(:to_s))
    end
  end

  def admin_calendar_link(date = nil)
    params[:category] ? 
      admin_calendars_path(:date => date.try(:to_s), :category => params[:category]) :
      admin_calendars_path(:date => date.try(:to_s))
  end

  def ria_events?
    action_name == 'ria'
  end

  def admin_calendars?
    params[:controller] == "admin/calendars"
  end

end
