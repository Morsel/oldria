module MessagesHelper

  def title_link_for_message(message)
    return unless message

    # Don't link the headers for broadcast-style messages
    return message.inbox_title if message.broadcast?

    link_path = if message.respond_to?(:holiday)
      holiday_discussion_path(message)
    elsif message.respond_to?(:admin_message)
      admin_conversation_path(message)
    elsif message.respond_to?(:discussionable)
      admin_discussion_path(message)
    else
      ria_messages_path # just in case
    end

    link_to message.inbox_title, link_path
  end

  def reply_link_for_message(message)
    return unless message

    if message.respond_to?(:holiday)
      link_to "Reply", holiday_discussion_path(message)
    elsif message.respond_to?(:admin_message)
      link_to "Reply", admin_conversation_path(message)
    elsif message.respond_to?(:discussionable)
      link_to "Reply", admin_discussion_path(message)
    end
  end

  def read_link_for_message(message, link_text = '<span>read</span>')
    return unless message

    if message.respond_to?(:holiday)
      link_path = read_holiday_discussion_reminder_path(message)
    elsif message.respond_to?(:discussionable)
      link_path = read_admin_discussion_path(message)
    else
      link_path = read_admin_message_path(message)
    end

    link_to(link_text, link_path, :class => 'readit')
  end

end