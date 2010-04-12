module MessagesHelper
  def reply_link_for_message(message)
    return unless message
    if message.respond_to?(:admin_message) && message.admin_message.respond_to?(:holiday)
      return unless holiday = message.admin_message.try(:holiday)
      rid = holiday.holiday_conversations.find_by_recipient_id(message.recipient_id)
      link_to "Reply", holiday_conversation_path(rid)
    elsif message.respond_to?(:admin_message)
      link_to "Reply", admin_conversation_path(message)
    elsif message.respond_to?(:discussionable)
      link_to "Reply", admin_discussion_path(message)
    end
  end


end