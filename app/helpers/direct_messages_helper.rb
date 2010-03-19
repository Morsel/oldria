module DirectMessagesHelper
  def details_for(dm)
    "<span>#{date_for(dm.created_at)}</span> <span>#{dm.sender.name_or_username}</span> #{dm.body}"
  end
end
