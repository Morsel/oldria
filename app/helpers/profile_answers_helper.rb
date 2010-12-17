module ProfileAnswersHelper
  def url_to_responder_question(answer)
    responder = answer.responder
    case true 
    when responder.is_a?(User)
      then soapbox_user_questions_url(responder, :chapter_id => answer.profile_question.chapter)
    when responder.is_a?(Restaurant)
      then soapbox_restaurant_questions_url(responder, :chapter_id => answer.profile_question.chapter)
    else
      raise "Unsupported responder type for sharing the question url"
    end
  end
end
