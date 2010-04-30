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
      "You sent a message to #{link_to direct_message.receiver.name_or_username, profile_path(direct_message.receiver.username)}"
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

  def show_reply_form?(direct_message)
    return false unless direct_message
    return false if @reply_form_already_shown

    # First message in the series
    if (direct_message == direct_message.root_message)
      return false if direct_message.from?(current_user)
      return @reply_form_already_shown = true if direct_message.responses.blank?
      return false if direct_message.responses.any? {|dm| !dm.from?(current_user) }
      last_response = direct_message && direct_message.responses.last
      return @reply_form_already_shown = true if last_response.from?(current_user)
    else # It's a later reply

      last_response = direct_message.parent && direct_message.parent.responses.last
      return @reply_form_already_shown = true if (last_response == direct_message) && !last_response.from?(current_user)
    end
  end

end
