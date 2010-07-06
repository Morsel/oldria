module EventsHelper
  
  def form_display(event)
    if event.new_record? && event.errors.blank?
      "display: none;"
    end
  end
end
