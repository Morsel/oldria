# == Schema Information
# Schema version: 20100316193326
#
# Table name: admin_messages
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  holiday_id   :integer
#

class Admin::ContentRequest < Admin::Message
  def self.title
    "Questions from Oz"
  end

  def attachments_allowed?
    true
  end

  def inbox_title
    message
  end
end
