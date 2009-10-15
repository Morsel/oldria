module MediaRequestsHelper
  
  def sent_date_and_recipient_count(media_request)
    count = media_request.media_request_conversations.size
    "You sent this #{time_ago_in_words(media_request.created_at)} ago to  #{pluralize(count, 'person')}"
  end
  
  def response_count(media_request)
    count = media_request.reply_count
    if count == 0
      "No one has responded"
    elsif count == 1
      "1 person has responded"
    else
      "#{count} people have responded"
    end
  end
end
