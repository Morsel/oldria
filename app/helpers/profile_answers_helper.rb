module ProfileAnswersHelper
  def url_to_responder_chapters(responder, topic_id)
    # FIXME - refactor code below to use an IF statement
    case true
    when responder.is_a?(Restaurant)
      then chapters_soapbox_restaurant_questions_url(responder, :topic_id => topic_id)
    when responder.is_a?(User)
      then chapters_soapbox_user_questions_url(responder, :topic_id => topic_id)
    else
      raise "Unsupported responder type for sharing the chapters url"
    end
  end
  
  def url_for_question(responder, chapter_id, profile_question_id = nil, for_soapbox = false)
    params = { :chapter_id => chapter_id, :anchor => (profile_question_id ? "profile_question_#{profile_question_id}" : nil) }
    if responder.is_a?(User)
      (soapbox? || for_soapbox) ? soapbox_user_questions_url(responder, params) : user_questions_url(responder, params)
    elsif responder.is_a?(Restaurant)
      (soapbox? || for_soapbox) ? soapbox_restaurant_questions_url(responder, params) : restaurant_questions_url(responder, params)
    else
      ""
    end
  end

  def url_to_responder_topics(responder)
    # FIXME - refactor code below to use an IF statement
    case true
    when responder.is_a?(Restaurant)
      then topics_soapbox_restaurant_questions_url(responder)
    when responder.is_a?(User)
      then topics_soapbox_user_questions_url(responder)
    else
      raise "Unsupported responder type for sharing the topics url"
    end  
  end
end
