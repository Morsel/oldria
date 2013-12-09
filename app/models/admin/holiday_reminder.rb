# == Schema Information
# Schema version: 20120217190417
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
  
  scope :current, lambda {
    {:conditions => ['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now]}
  }
  
  before_save :update_discussions
  attr_accessible :holiday_id,:message

  def self.title
    "Holiday Reminder"
  end

  def inbox_title
    holiday && holiday.name
  end
  
  def email_title
    "Reminder for #{inbox_title}"
  end
  
  def update_discussions
    self.holiday_discussions = self.holiday.holiday_discussions.needs_reply if self.holiday
  end
    
end
