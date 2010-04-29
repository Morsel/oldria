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

end
