class HolidayDiscussionReminder < ActiveRecord::Base
  
  acts_as_readable
  
  belongs_to :holiday_discussion
  belongs_to :holiday_reminder, :class_name => "Admin::HolidayReminder"
  
  def inbox_title
    holiday_reminder.inbox_title
  end
  
end
