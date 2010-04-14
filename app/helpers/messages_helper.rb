module MessagesHelper
  def reply_link_for_message(message)
    return unless message
    if message.respond_to?(:holiday)
      #rid = holiday.holiday_discussions.find_by_restaurant_id(message.restaurant_id)
      #link_to "Reply", holiday_discussion_path(rid)
    elsif message.respond_to?(:admin_message)
      link_to "Reply", admin_conversation_path(message)
    elsif message.respond_to?(:discussionable)
      link_to "Reply", admin_discussion_path(message)
    end
  end

  def read_link_for_message(message, link_text = '<span>read</span>')
    return unless message

    if message.respond_to?(:discussionable)
      link_path = read_admin_discussion_path(message)
    else
      link_path = read_admin_message_path(message)
    end

    link_to(link_text, link_path, :class => 'readit')
  end

end