class MediaRequest < ActiveRecord::Base
  serialize :fields, Hash

  belongs_to :sender, :class_name => 'User'
  belongs_to :media_request_type
  has_many :media_request_conversations
  has_many :conversations_with_comments, :class_name => 'MediaRequestConversation', :conditions => 'comments_count > 0'

  has_many :recipients, :through => :media_request_conversations
  has_many :attachments, :as => :attachable, :class_name => '::Attachment'
  validates_presence_of :sender_id

  accepts_nested_attributes_for :attachments

  named_scope :past_due, lambda {{ :conditions => ['due_date < ?', Date.today] }}


  include AASM

  aasm_column :status
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :approved
  aasm_state :closed

  aasm_event :approve, :success => :deliver_notification do
    transitions :to => :approved, :from => [:pending]
  end

  def deliver_notification
    UserMailer.deliver_media_request_notification(self)
  end

  def conversation_with_recipient(user)
    media_request_conversations.first(:conditions => {:recipient_id => user.id})
  end

  def reply_count
    @reply_count ||= conversations_with_comments.size
  end
  
  def message_with_fields(before_key = '', after_key = ': ')
    message_with_fields = fields.inject("") do |result, (key,value)|
      result += "#{before_key + key.to_s.humanize + after_key + value}\n"
    end
    return message_with_fields if message.blank?
    message_with_fields += "\n#{message}"
  end
  
  def fields=(fields)
    fields.delete_if {|k,v| v.blank? } if fields.respond_to?(:delete_if)
    write_attribute(:fields, fields)
  end

  def fields
    read_attribute(:fields) || Hash.new
  end

end
