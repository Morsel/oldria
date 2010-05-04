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
      :conditions => ['admin_messages.scheduled_at < ? OR admin_messages.scheduled_at IS NULL', Time.zone.now]  }
    }
  named_scope :with_replies, :conditions => "comments_count > 0"
  named_scope :without_replies, :conditions => "comments_count = 0"

  belongs_to :recipient, :class_name => "Employment"
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
  
  def message
    admin_message.message
  end
  
  def scheduled_at
    admin_message.scheduled_at
  end
  
  def self.with_unread_replies(user)
    user.admin_conversations.each { |c| c.comments.reject { |c| c.read_by?(user) } }.flatten
  end
  
end
