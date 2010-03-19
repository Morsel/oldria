module DirectMessagesHelper
  def details_for(dm)
    "#{dm.body} #{dm.sender.name_or_username} #{date_for(dm.created_at)}"
  end
end
