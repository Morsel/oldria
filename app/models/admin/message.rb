# == Schema Information
#
# Table name: admin_messages
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  sent_at    :datetime
#  status     :string(255)
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#

class Admin::Message < ActiveRecord::Base
  set_table_name "admin_messages"

  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'admin_message_id', :dependent => :destroy
  has_many :recipients, :through => :admin_conversations
  validates_presence_of :message

  before_create :add_everyone_as_recipients_if_broadcast

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

  def broadcast?
    false
  end

  def recipients_can_reply?
    true
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

  protected

  def add_everyone_as_recipients_if_broadcast
    self.recipients = Employment.all if broadcast?
  end
end
