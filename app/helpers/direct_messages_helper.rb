module DirectMessagesHelper

  def details_for(dm)
    "<span>#{date_for(dm.created_at)}</span> <span>#{dm.sender.name_or_username}</span> #{truncate(dm.body, :length => 100)}"
  end

  def display_form(dm)
    if (dm == @current_message) && dm.responses.blank?
      "display: block;"
    else
      "display: none;"
    end
  end

  def title_for_direct_message(direct_message)
    return unless direct_message
    if direct_message.sender_id == current_user.try(:id)
      %(You sent a message to #{link_to(direct_message.receiver.name_or_username, profile_path(direct_message.receiver.username))}).html_safe
    else
      "#{link_to direct_message.sender.name_or_username, profile_path(direct_message.sender.username)} sent you a message"
    end
  end

  def css_classes_for_direct_message(direct_message)
    return unless direct_message
    classes = "clearfix"
    classes << ' sent_message' if direct_message.from?(current_user)
    classes << (direct_message.read_by?(current_user) ? ' read' : ' unread')
    classes
  end

  def set_latest_reply_id(direct_message)
    return unless direct_message
    @reply_to_dm = direct_message
  end
  
  def reply_recipient(direct_message)
    direct_message.sender == current_user ? direct_message.receiver : direct_message.sender
  end

end
