# == Schema Information
# Schema version: 20100415205144
#
# Table name: holiday_discussion_reminders
#
#  id                    :integer         not null, primary key
#  holiday_discussion_id :integer
#  holiday_reminder_id   :integer
#  created_at            :datetime
#  updated_at            :datetime
#

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
  
  def email_title
    inbox_title
  end

  def holiday
    holiday_discussion.holiday
  end

  def restaurant
    holiday_discussion.restaurant
  end

  def message
    holiday_reminder.message
  end

  def scheduled_at
    holiday_reminder.scheduled_at
  end

  def employees
    restaurant ? restaurant.employees : []
  end

  # Should only be called from an external observer.
  def notify_recipients
    for recipient in employees
      if recipient.prefers_receive_email_notifications
        UserMailer.send_at(scheduled_at, :deliver_message_notification, self.holiday_reminder, recipient)
      end
    end
  end

end
