module ProfileHelper

  # object must respond to both date_started and date_ended
  def date_range(object)
    st = object.date_started.try(:strftime, "%b %Y")
    en = if object.date_ended
      object.date_ended.try(:strftime, "%b %Y")
    else
      "Present"
    end

    "#{st} - #{en}"
  end
end