class Admin::Conversation < ActiveRecord::Base
  set_table_name "admin_conversations"
  acts_as_commentable

  belongs_to :recipient, :class_name => "Employment"
  belongs_to :admin_message, :foreign_key => 'admin_message_id', :class_name => 'Admin::Message'
end
