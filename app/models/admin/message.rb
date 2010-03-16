# == Schema Information
# Schema version: 20100303185000
#
# Table name: admin_messages
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  holiday_id   :integer
#

class Admin::Message < ActiveRecord::Base
  set_table_name "admin_messages"
  acts_as_readable

  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'admin_message_id', :dependent => :destroy
  has_many :recipients, :through => :admin_conversations
  validates_presence_of :message

  named_scope :current, lambda {
    {:conditions => ['admin_messages.scheduled_at < ? OR admin_messages.scheduled_at IS NULL', Time.zone.now]}
  }

  include AASM
  aasm_column :status
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :sent

  aasm_event :deliver do
    transitions :to => :sent, :from => [:draft]
  end

  def self.title
    raise NoMethodError, "You need to set self.title on each subclass"
  end

  def self.shorttitle
    self.title
  end

  def inbox_title
    self.class.title
  end

  def broadcast?
    false
  end

  def recipients_can_reply?
    true
  end

  def current?
    scheduled_at < Time.zone.now
  end

  def reply_count
    conversations_with_replies.count
  end

  def conversations_with_replies
    admin_conversations.scoped(:conditions => "comments_count > 0", :include => {:recipient => :employee})
  end

  def conversations_without_replies
    admin_conversations.scoped(:conditions => "comments_count < 1", :include => {:recipient => :employee})
  end

  def attachments_allowed?
    false
  end
end
