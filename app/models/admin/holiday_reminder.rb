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

class Admin::HolidayReminder < Admin::Message
  belongs_to :holiday

  before_create :copy_recipients

  def copy_recipients
    return if holiday.blank? || recipient_ids.present?
    self.recipient_ids = holiday.employment_search.restaurants.map(&:id) - holiday.accepted_holiday_discussion_restaurant_ids
  end

  def self.title
    "Holiday Reminder"
  end

  def inbox_title
    holiday && holiday.name
  end
end
