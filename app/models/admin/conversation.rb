# == Schema Information
# Schema version: 20120217190417
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

  attr_accessible :recipient_id, :admin_message_id, :comments_count
  attr_accessor :user,:user_id


  scope :current, lambda {
    { :joins => :admin_message,
      :conditions => ['admin_messages.scheduled_at < ? OR admin_messages.scheduled_at IS NULL', Time.zone.now],
      :order => 'admin_messages.scheduled_at DESC'  }
    }

  scope :recent, lambda {
    { :conditions => ['admin_messages.scheduled_at >= ?', 2.weeks.ago] }
  }

  scope :with_replies, :conditions => "comments_count > 0"
  scope :without_replies, :conditions => "comments_count = 0"

  belongs_to :recipient, :class_name => "User"
  belongs_to :admin_message, :foreign_key => 'admin_message_id', :class_name => 'Admin::Message'

  def inbox_title
    admin_message.inbox_title
  end

  def email_title
    inbox_title
  end

  def short_title
    "qotd"
  end
  
  def email_body
    admin_message.message
  end
  
  def message
    admin_message.message
  end

  def display_message
    admin_message.display_message
  end

  def scheduled_at
    admin_message.scheduled_at
  end
  
  def soapbox_entry
    admin_message.soapbox_entry
  end

  def recipients_can_reply?
    true
  end

  def create_response_for_user(user, comment)
    self.comments.create(:user => user, :comment => comment)
  end

  # Should only be called from an external observer.
  def notify_recipients
    self.send_at(scheduled_at, :queued_message_sending)
  end

  # Should only be called from the notify_recipients queued action
  def queued_message_sending
    if recipient.prefers_receive_email_notifications
      # we send some messgaes to the different mailer
      UserMailer.send("deliver_#{admin_message.mailer_method}", self, recipient)
    end
  end

end
