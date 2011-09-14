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
    elsif message.respond_to?(:admin_message) # QOTD
      admin_conversation_path(message)
    elsif message.respond_to?(:discussionable) # AdminDiscussion for TrendQuestion or ContentRequest
      admin_discussion_path(message)
    elsif message.respond_to?(:admin_discussions) # TrendQuestion or ContentRequest
      if current_user.grouped_admin_discussions[message].blank? # no admin_discussion for this user
        current_user.admin? ? 
            "" : 
            solo_discussion_path(message.solo_discussions.find_by_employment_id(current_user.primary_employment.try(:id)))
      else
        first_discussion_for_user = current_user.grouped_admin_discussions[message].first
        admin_discussion_path(first_discussion_for_user)
      end
    elsif message.respond_to?(:employment)
      solo_discussion_path(message)
    else
      ria_messages_path # just in case
    end

    link_path
  end

  def reply_link_for_message(message)
    return unless message
    return if message.respond_to?(:broadcast?) && message.broadcast?
    
    link_path = link_for_message(message)
    
    if message.comments_count == 0
      link_to "Post", link_path, :class => 'button utility round'
    else
      link_to "View your post", link_path, :class => 'button utility round'
    end
  end

  def unread_message?(message, user)
    if message.respond_to?(:admin_discussions) # TrendQuestion or ContentRequest
      first_discussion_for_user = user.grouped_admin_discussions[message].first
      !first_discussion_for_user.read_by?(user)
    else
      !message.read_by?(user)
    end
  end

  def read_link_for_message(message, link_text = '<span>Read message</span>')
    return unless message

    link_path = if message.is_a?(HolidayDiscussion)
      read_holiday_discussion_path(message)
    elsif message.respond_to?(:holiday)
      read_holiday_discussion_reminder_path(message)
    elsif message.respond_to?(:discussionable)
      read_admin_discussion_path(message)
    elsif message.respond_to?(:admin_message) # QOTD
      read_admin_conversation_path(message)
    elsif message.respond_to?(:admin_discussions) # TrendQuestion or ContentRequest
      first_discussion_for_user = current_user.grouped_admin_discussions[message].first
      read_admin_discussion_path(first_discussion_for_user)
    elsif message.respond_to?(:employment)
      read_solo_discussion_path(message)
    else
      read_admin_message_path(message)
    end

    link_to(link_text, link_path, :class => 'readit')
  end

  def classes(message)
    defaults = "inbox_message clear clearfix"
    defaults += " archived" if message.read_by?(current_user)
    defaults += " #{dom_class(message.discussionable)}" if message.respond_to?(:discussionable)
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

  def not_responded_phrase_for_discussions(discussions_without_replies)
    return if discussions_without_replies.blank?

    restuarants = discussions_without_replies.map(&:restaurant)

    restaurant_phrase = restuarants.map do |restaurant|
      "<span>#{restaurant.try(:name)}</span>"
    end.to_sentence

    if discussions_without_replies.length > 1
      phrase = "have not responded"
    else
      phrase = "has not responded"
    end

    return "#{restaurant_phrase} #{phrase}."
  end

  def show_replies?
    params[:action] == "ria"
  end
  
  def show_replies_block?(message)
    !message.read_by?(current_user)
  end
  
  def css_classes_for_discussion(discussion)
    classes = 'inbox_message'
    classes << ' archived' if discussion.read_by?(current_user)
    classes
  end
  
  def announcement?(message)
     message.inbox_title == "Announcement"
  end
  
  def ria_messages?
    params[:action] == "ria"
  end

end