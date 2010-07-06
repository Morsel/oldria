module EventsHelper
  
  def form_display(event)
    if event.new_record?
      "display: none;"
    end
  end
end
