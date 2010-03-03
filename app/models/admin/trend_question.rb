# == Schema Information
# Schema version: 20100303185000
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

class Admin::TrendQuestion < Admin::Message
  def self.title
    "Seasonal/Trend Question"
  end

  def self.shorttitle
    "Trend Question"
  end
end
