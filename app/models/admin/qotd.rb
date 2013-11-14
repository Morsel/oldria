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

class Admin::Qotd < Admin::Message

  # TODO - figure out why :as => :featured_item isn't working here
  has_one :soapbox_entry, :foreign_key => :featured_item_id, :conditions => { :featured_item_type => "Admin::Qotd" }, :dependent => :destroy

  scope :current, :conditions => ['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now]
  
  attr_protected
  
  def self.title
    "Question of the Day"
  end

  def self.shorttitle
    "QOTD"
  end

  def title
    self.class.title
  end
  
  def recipients_can_reply?
    true
  end
  
  def soapbox_comment_count
    admin_conversations.with_replies.count
  end

  def mailer_method
    'answerable_message_notification'
  end
  
end
