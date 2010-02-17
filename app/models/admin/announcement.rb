class Admin::Announcement < Admin::Message
  def self.title
    "Announcement"
  end

  ##
  # This will add everyone as a recipient
  def broadcast?
    true
  end
end
