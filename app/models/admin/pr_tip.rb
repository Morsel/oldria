class Admin::PrTip < Admin::Message
  def self.title
    "PR Tip"
  end

  ##
  # This will add everyone as a recipient
  def broadcast?
    true
  end

  ##
  # This will disable commenting (replying)
  def recipients_can_reply?
    false
  end
end
