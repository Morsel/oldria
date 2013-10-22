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
  
  def years_for_select
    (1930..Date.today.year).map(&:to_s).to_a.reverse
  end

  def setup_enrollment(enrollment, culinary = true)
    enrollment.tap do |e|
      e.build_school unless e.school.present?
    end
    # return @e
  end

  def setup_nonculinary_enrollment(enrollment)
    enrollment.tap do |e|
      e.build_nonculinary_school unless e.nonculinary_school.present?
    end
  end
  
  def privacy_options
    [["Nobody!", "private"], ["Just Chefs in Spoonfeed", "spoonfeed"], ["The public at large", "everyone"]]
  end
  
  def age(birthday)
    result = Date.today.year - birthday.year
    result -= 1 if Date.today < birthday + result.years
    result
  end

  def user_topics(user)
    if can?(:manage, user)
      user.topics_without_travel
    else
      user.published_topics_without_travel
    end
  end

end
