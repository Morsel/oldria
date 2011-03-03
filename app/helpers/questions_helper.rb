module QuestionsHelper
  def topics_for(subject)
    if can_edit_profile_questions(subject)
      subject.topics
    else
      if subject.is_a? RestaurantFeaturePage
        subject.published_topics(Restaurant.find(params[:restaurant_id]))
      else
        subject.published_topics
      end

    end
  end

  def can_edit_profile_questions(subject)
    # FIXME - this check breaks if the subject is a RestaurantFeaturePage and you are a restaurant manager
    # the manager should be able to edit profile questions in the context of the RestaurantFeaturePage
    can?(:manage, subject)
  end

  def btl_title_for(subject)
    title_text = subject.name
    if subject.is_a? RestaurantFeaturePage
      restaurant = Restaurant.find(params[:restaurant_id])
      title_text = "#{restaurant.try(:name)} - #{title_text}"
    end
    title_text
  end

  def btl_description_for_fb(answers)
    output = []
    unless answers.nil?
      answers.first(5).each do |answer|
        output << truncate(answer.answer, :length => 25)
      end
    end
    output.join(' | ')
  end
  
  def find_btl_url_for subject
    if subject.is_a?(User)
      subject.premium_account ? soapbox_profile_path(subject.username) : profile_url(subject.username)
    elsif subject.is_a?(Restaurant)
      subject.premium_account ? soapbox_restaurant_path(subject) : restaurant_url(subject)      
    end
  end
end
