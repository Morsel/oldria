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

  named_scope :current, lambda {
    { :joins => :admin_message,
      :conditions => ['admin_messages.scheduled_at < ? OR admin_messages.scheduled_at IS NULL', Time.zone.now]  }
    }

  belongs_to :recipient, :class_name => "Employment"
  belongs_to :admin_message, :foreign_key => 'admin_message_id', :class_name => 'Admin::Message'
end
