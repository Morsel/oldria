module ProfileAnswersHelper
  def url_to_responder_question(responder, chapter_id)
    case true 
    when responder.is_a?(User)
      then soapbox_user_questions_url(responder, :chapter_id => chapter_id)
    when responder.is_a?(Restaurant)
      then soapbox_restaurant_questions_url(responder, :chapter_id => chapter_id)
    else
      raise "Unsupported responder type for sharing the question url"
    end
  end
end
