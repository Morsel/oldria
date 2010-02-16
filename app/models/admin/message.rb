class Admin::Message < ActiveRecord::Base
  set_table_name "admin_messages"

  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'admin_message_id'
  has_many :recipients, :through => :admin_conversations
  validates_presence_of :message

  include AASM
  aasm_column :status
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :sent

  aasm_event :deliver do
    transitions :to => :sent, :from => [:draft]
  end

  def self.title
    raise NoMethodError, "You need to set self.title method on each subclass"
  end

end
