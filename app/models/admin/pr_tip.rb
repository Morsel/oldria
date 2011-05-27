# == Schema Information
# Schema version: 20110526212923
#
# Table name: admin_messages
#
#  id              :integer         not null, primary key
#  type            :string(255)
#  scheduled_at    :datetime
#  status          :string(255)
#  message         :text
#  created_at      :datetime
#  updated_at      :datetime
#  display_message :string(255)
#  slug            :string(255)
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

  # Should only be called from an external observer.
  def notify_recipients
    for user in User.receive_email_notifications
      UserMailer.send_at(scheduled_at, :deliver_message_notification, self, user)
    end
  end

end
