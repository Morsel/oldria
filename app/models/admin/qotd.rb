# == Schema Information
# Schema version: 20100811200806
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
#  holiday_id      :integer
#  display_message :string(255)
#

class Admin::Qotd < Admin::Message

  # TODO - figure out why :as => :featured_item isn't working here
  has_one :soapbox_entry, :foreign_key => :featured_item_id, :conditions => { :featured_item_type => "Admin::Qotd" }, :dependent => :destroy

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
end
