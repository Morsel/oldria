module MessagesHelper

  def title_link_for_message(message)
    return unless message
    # Don't link the headers for broadcast-style messages
    return message.inbox_title if message.respond_to?(:broadcast?) && message.broadcast?

    link_path = link_for_message(message)
    link_to message.inbox_title, link_path
  end

  def link_for_message(message)
    link_path = if message.is_a?(HolidayDiscussion)
      holiday_discussion_path(message)
    elsif message.respond_to?(:holiday)
      holiday_discussion_path(message.holiday_discussion)
    elsif message.respond_to?(:admin_message)
      admin_conversation_path(message)
    elsif message.respond_to?(:discussionable)
      admin_discussion_path(message)
    else
      ria_messages_path # just in case
    end

    link_path
  end

  def reply_link_for_message(message)
    return unless message
    return if message.respond_to?(:broadcast?) && message.broadcast?
    link_path = link_for_message(message)
    link_to "Reply", link_path, :class => 'button utility round'
  end

  def read_link_for_message(message, link_text = '<span>read</span>')
    return unless message

    if message.respond_to?(:holiday)
      link_path = read_holiday_discussion_reminder_path(message)
    elsif message.respond_to?(:discussionable)
      link_path = read_admin_discussion_path(message)
    elsif message.respond_to?(:admin_message)
      link_path = read_admin_message_path(message.admin_message)
    else
      link_path = read_admin_message_path(message)
    end

    link_to(link_text, link_path, :class => 'readit')
  end

  def classes(message)
    defaults = "inbox_message clear clearfix"
    defaults += " archived" if message.read_by?(current_user)
    defaults += " #{dom_class(message.discussionable)}" if message.respond_to?(:discussionable)
    defaults += " action" if message.respond_to?(:action_required?) && message.action_required?(current_user)
    defaults
  end

  def restaurant(message)
    if message.respond_to?(:recipient)
      restaurant = message.recipient.try(:restaurant)
    elsif message.respond_to?(:restaurant)
      restaurant = message.restaurant
    elsif message.respond_to?(:discussionable) || message.is_a?(HolidayDiscussionReminder)
      restaurant = message.restaurant
    end
  end

  def show_replies?
    params[:action] == "ria"
  end
  
  def show_replies_block?(message)
    if message.is_a?(HolidayDiscussion)
      false
    else
      !message.read_by?(current_user)
    end
  end
  
  def show_replies_link?(message)
    message.respond_to?(:action_required?) && message.action_required?(current_user)
  end

  def css_classes_for_discussion(discussion)
    classes = 'inbox_message'
    classes << ' action_required' if discussion.action_required?(current_user)
    classes << ' archived' if discussion.read_by?(current_user)
    classes
  end

end