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

class Admin::HolidayReminder < ActiveRecord::Base
  
  belongs_to :holiday
  has_many :holiday_discussion_reminders
  has_many :holiday_discussions, :through => :holiday_discussion_reminders
  
  named_scope :current, lambda {
    {:conditions => ['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now]}
  }

  def self.title
    "Holiday Reminder"
  end

  def inbox_title
    holiday && holiday.name
  end
    
end
