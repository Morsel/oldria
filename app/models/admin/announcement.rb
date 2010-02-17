class Admin::Announcement < Admin::Message
  def self.title
    "Announcement"
  end

  before_create :add_everyone_as_recipients

  def broadcast?
    true
  end

end
