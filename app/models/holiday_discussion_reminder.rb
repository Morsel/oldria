# == Schema Information
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

  scope :current, lambda {
    { :joins => :holiday_reminder,
      :conditions => ['holiday_reminders.scheduled_at < ? OR holiday_reminders.scheduled_at IS NULL', Time.zone.now]  }
    }

  scope :recent, lambda {
    { :joins => :holiday_reminder,
      :conditions => ['holiday_reminders.scheduled_at >= ?', 2.weeks.ago] }
  }

  scope :with_replies, :joins => :holiday_discussion, :conditions => 'holiday_discussions.comments_count > 0'

  def inbox_title
    holiday_reminder.inbox_title
  end

  def email_title
    holiday_reminder.email_title
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

  def comments_count
    holiday_discussion.comments_count
  end

  def employees
    restaurant ? restaurant.employees : []
  end

  # Should only be called from an external observer.
  def notify_recipients
    self.send_at(scheduled_at, :queued_message_sending)
  end

  def queued_message_sending
    for recipient in employees
      if recipient.prefers_receive_email_notifications
        UserMailer.message_notification(self, recipient).deliver
      end
    end
  end

  def comments
    holiday_discussion.comments
  end

  def comments_count
    holiday_discussion.comments_count
  end
  
  def recipients_can_reply?
    true
  end

end
