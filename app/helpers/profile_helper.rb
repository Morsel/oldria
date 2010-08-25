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

  def setup_enrollment(enrollment, culinary = true)
    returning(enrollment) do |e|
      e.build_school unless e.school.present?
    end
  end  
end
