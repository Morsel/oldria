# == Schema Information
# Schema version: 20100303182810
#
# Table name: holidays
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  date       :date
#  created_at :datetime
#  updated_at :datetime
#

class Holiday < ActiveRecord::Base
  has_many :admin_holiday_reminders, :class_name => 'Admin::HolidayReminder', :dependent => :destroy
  has_many :holiday_conversations, :dependent => :destroy
  has_many :recipients, :through => :holiday_conversations

  accepts_nested_attributes_for :admin_holiday_reminders
  validates_presence_of :name
  validates_presence_of :date

  def reminders_count
    admin_holiday_reminders.size
  end
end
