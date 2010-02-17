class Admin::Announcement < Admin::Message
  def self.title
    "Announcement"
  end

  def broadcast?
    true
  end
end
