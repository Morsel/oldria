class Admin::Message < ActiveRecord::Base
  set_table_name "admin_messages"

  has_many :admin_conversations, :class_name => 'Admin::Conversation', :foreign_key => 'admin_message_id'
  has_many :recipients, :through => :admin_conversations

end
