# == Schema Information
#
# Table name: admin_conversations
#
#  id               :integer         not null, primary key
#  recipient_id     :integer
#  admin_message_id :integer
#  comments_count   :integer         default(0), not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Admin::Conversation < ActiveRecord::Base
  set_table_name "admin_conversations"
  acts_as_commentable
  acts_as_readable

  named_scope :current, lambda {
    { :joins => :admin_message,
      :conditions => ['admin_messages.scheduled_at < ? OR admin_messages.scheduled_at IS NULL', Time.zone.now],
      :order => 'admin_messages.scheduled_at DESC'  }
    }

  named_scope :recent, lambda {
    { :conditions => ['admin_messages.scheduled_at >= ?', 2.weeks.ago] }
  }

  named_scope :with_replies, :conditions => "comments_count > 0"
  named_scope :without_replies, :conditions => "comments_count = 0"

  belongs_to :recipient, :class_name => "User"
  belongs_to :admin_message, :foreign_key => 'admin_message_id', :class_name => 'Admin::Message'

  named_scope :unread_by, lambda { |user|
     { :joins => "LEFT OUTER JOIN readings ON #{table_name}.id = readings.readable_id
       AND readings.readable_type = '#{self.to_s}'
       AND readings.user_id = #{user.id}",
       :conditions => 'readings.user_id IS NULL' }
  }

  def inbox_title
    admin_message.inbox_title
  end

  def email_title
    inbox_title
  end

  def message
    admin_message.message
  end

  def scheduled_at
    admin_message.scheduled_at
  end

  def recipients_can_reply?
    true
  end

  def self.action_required(user)
    self.with_replies.unread_by(user).reject { |c| c.comments.last.user == user }
  end

  def action_required?(user)
    false
    # !read_by?(user) && comments_count > 0 && comments.last.user != user
  end

  # Should only be called from an external observer.
  def notify_recipients
    self.send_at(scheduled_at, :queued_message_sending)
  end

  # Should only be called from the notify_recipients queued action
  def queued_message_sending
    if recipient.prefers_receive_email_notifications
      UserMailer.deliver_message_notification(self, recipient)
    end
  end

  def restaurant
    recipient.try(:restaurant)
  end
  
end
