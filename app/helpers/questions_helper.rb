module QuestionsHelper
  def topics_for(subject)
    if can_edit_profile_questions(subject)
      subject.topics
    else
      subject.published_topics
    end
  end

  def can_edit_profile_questions(subject)
    if subject.is_a? User
      current_user == subject
    else
      can?(:manage, subject)
    end
  end
end
