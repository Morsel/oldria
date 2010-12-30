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
    title_text
  end

  def btl_description_for_fb(question, answers)
    output = truncate(question.title, :length => 100) + "\n"
    answers.each do |answer|
      output << truncate(answer.answer, :length => 30) + "\n"
    end
    output
  end
end
