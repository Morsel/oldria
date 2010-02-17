class Admin::PrTip < Admin::Message
  def self.title
    "PR Tip"
  end

  def broadcast?
    true
  end

  def recipients_can_reply?
    false
  end
end
