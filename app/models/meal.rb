# == Schema Information
# Schema version: 20120217190417
#
# Table name: meals
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  day                      :string(255)
#  open_at_hours            :string(255)
#  open_at_minutes          :string(255)
#  open_at_am_pm            :string(255)
#  closed_at_hours          :string(255)
#  closed_at_minutes        :string(255)
#  closed_at_am_pm          :string(255)
#  restaurant_fact_sheet_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class Meal < ActiveRecord::Base
  DAYS = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
  scope :for_day, lambda { |day|
    { :conditions => {:day => day} }
  }
  attr_accessible :name, :open_at_hours, :open_at_minutes, :open_at_am_pm, :closed_at_hours, :closed_at_minutes, :closed_at_am_pm, :day, :restaurant_fact_sheet_id
  validates_presence_of :name, :day, :open_at_hours, :open_at_minutes, :open_at_am_pm, :closed_at_hours, :closed_at_minutes, :closed_at_am_pm
  validates_inclusion_of :day, :in => DAYS

  def open_at
    "#{open_at_hours}:#{open_at_minutes}#{open_at_am_pm}"
  end

  def closed_at
    "#{closed_at_hours}:#{closed_at_minutes}#{closed_at_am_pm}"
  end
end
