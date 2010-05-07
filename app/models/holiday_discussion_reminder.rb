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
  
  named_scope :with_replies, :joins => :holiday_discussion, :conditions => 'holiday_discussions.comments_count > 0'
  
  def inbox_title
    holiday_reminder.inbox_title
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
  
  def comments
    holiday_discussion.comments
  end
  
  def comments_count
    holiday_discussion.comments_count
  end
  
  def self.action_required(user)
    self.with_replies.reject { |h| h.read_by?(user) }#.reject { |h| h.comments.last.user == user }
  end
  
  def action_required?(user)
    !read_by?(user) && comments_count > 0 && comments.last.user != user
  end
  
end
