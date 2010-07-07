module Admin::CalendarsHelper

  def event_link(event)
    if params[:controller] == "admin/calendars"
      admin_event_path(event)
    elsif @restaurant
      transfer_restaurant_events_path(:restaurant_id => @restaurant.id, :id => event.id)
    end
  end

end
