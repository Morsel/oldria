class Admin::ContentRequest < Admin::Message
  def self.title
    "Questions from Oz"
  end

  def attachments_allowed?
    true
  end
end
