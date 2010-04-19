class HolidayDiscussionReminder < ActiveRecord::Base
  
  acts_as_readable
  
  belongs_to :holiday_discussion
  belongs_to :holiday_reminder, :class_name => "Admin::HolidayReminder"
  
  named_scope :current, lambda {
    { :joins => :holiday_reminder,
      :conditions => ['holiday_reminders.scheduled_at < ? OR holiday_reminders.scheduled_at IS NULL', Time.zone.now]  }
    }
  
  def inbox_title
    holiday_reminder.inbox_title
  end
  
  def holiday
    holiday_discussion.holiday
  end
  
  def restaurant
    holiday_discussion.restaurant
  end
  
end
