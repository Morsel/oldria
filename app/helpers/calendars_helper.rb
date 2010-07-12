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

  def restaurant_calendar_link(restaurant, date = nil)
    if restaurant && ria_events?
      ria_restaurant_calendars_path(:restaurant_id => restaurant, :date => date.try(:to_s))
    elsif restaurant
      restaurant_calendars_path(:restaurant_id => restaurant, :date => date.try(:to_s))
    end
  end

  def ria_events?
    action_name == 'ria'
  end

  def admin_calendars?
    params[:controller] == "admin/calendars"
  end

end
