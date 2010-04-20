# == Schema Information
# Schema version: 20100415205144
#
# Table name: holiday_reminders
#
#  id           :integer         not null, primary key
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  holiday_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
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
