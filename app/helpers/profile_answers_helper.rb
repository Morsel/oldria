module ProfileAnswersHelper
  def url_to_responder_chapters(responder, topic_id)
    case true
    when responder.is_a?(Restaurant)
      then chapters_soapbox_restaurant_questions_url(responder, :topic_id => topic_id)
    when responder.is_a?(User)
      then chapters_soapbox_user_questions_url(responder, :topic_id => topic_id)
    else
      raise "Unsupported responder type for sharing the chapters url"
    end
  end
  
  def url_to_responder_question(responder, chapter_id, profile_question_id=nil)
    case true 
    when responder.is_a?(User)
      then soapbox_user_questions_url(responder, :chapter_id => chapter_id,
             :anchor => profile_question_id ? "profile_question_#{profile_question_id}" : nil)
    when responder.is_a?(Restaurant)
      then soapbox_restaurant_questions_url(responder, :chapter_id => chapter_id,
             :anchor => profile_question_id ? "profile_question_#{profile_question_id}" : nil)
    else
      raise "Unsupported responder type for sharing the question url"
    end
  end

  def url_to_responder_topics(responder)
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
