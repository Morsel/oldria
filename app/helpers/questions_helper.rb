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
    if subject.is_a? User
      current_user == subject
    else
      can?(:manage, subject)
    end
  end

  def btl_title_for(subject)
    title_text = subject.name
    if subject.is_a? RestaurantFeaturePage
      restaurant = Restaurant.find(params[:restaurant_id])
      title_text = "#{restaurant.name} - #{title_text}"
    end
  end
end
