# == Schema Information
# Schema version: 20120217190417
#
# Table name: admin_messages
#
#  id              :integer         not null, primary key
#  type            :string(255)
#  scheduled_at    :datetime
#  status          :string(255)
#  message         :text
#  created_at      :datetime
#  updated_at      :datetime
#  display_message :string(255)
#  slug            :string(255)
#

class Admin::Message < ActiveRecord::Base
  set_table_name "admin_messages"
  acts_as_readable

  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'admin_message_id', :dependent => :destroy
  has_many :recipients, :through => :admin_conversations
  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  accepts_nested_attributes_for :attachments

  validates_presence_of :message
  validates_length_of :slug, :maximum => 30, :allow_nil => true

  scope :current, lambda {
    { :conditions => ['admin_messages.scheduled_at < ? OR admin_messages.scheduled_at IS NULL', Time.zone.now] }
  }

  scope :recent, lambda {
    { :conditions => ['admin_messages.scheduled_at >= ?', 2.weeks.ago] }
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

  def email_title
    inbox_title
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

  def self.on_soapbox_with_response_from_user(user = nil)
    return [] unless user
    self.all(:joins => [:soapbox_entry, {:admin_conversations => :comments}], 
        :conditions => ['comments.user_id = ?', user.id], :group => 'admin_messages.id', :limit => 5)
  end

  def comments(deep_includes = false)
    includes = deep_includes ? :user : nil
    Comment.scoped(:conditions => ["commentable_id IN (?) AND commentable_type = 'Admin::Conversation'",
      admin_conversations.all(:select => "id").map { |d| d.id }],
      :include => includes, :group => "comments.id")
  end

  def last_comment
    comments.first(:order => "comments.created_at DESC", :limit => 1)
  end

  def conversations_with_replies
    admin_conversations.scoped.where('comments_count > 0', :include => :recipient)
  end

  def conversations_without_replies
    admin_conversations.scoped.where('comments_count < 1', :include => :recipient)
  end

  def attachments_allowed?
    false
  end
  
  def mailer_method
    'message_notification'  
  end
  
end
