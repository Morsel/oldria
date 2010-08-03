module EventsHelper
  
  def form_display(event)
    if event.new_record? && event.errors.blank?
      "display: none;"
    end
  end
  
  def status_display(event)
    if event.new_record? && event.errors.blank?
      "display: none;"
    elsif event.category != "Private"
      "display: none;"
    end
  end
  
end
