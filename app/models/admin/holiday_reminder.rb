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

class Admin::HolidayReminder < ActiveRecord::Base
  acts_as_commentable
  acts_as_readable

  belongs_to :holiday
  has_and_belongs_to_many :holiday_discussions
  
  named_scope :current, lambda {
    {:conditions => ['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now]}
  }

  def self.title
    "Holiday Reminder"
  end

  def inbox_title
    holiday && holiday.name
  end
  
end
