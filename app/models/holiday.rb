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
  has_many :admin_holiday_reminders, :class_name => 'Admin::HolidayReminder'
  validates_presence_of :name
  validates_presence_of :date
end
