# == Schema Information
#
# Table name: admin_messages
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  sent_at    :datetime
#  status     :string(255)
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#

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
