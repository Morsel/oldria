class Meal < ActiveRecord::Base
  DAYS = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
  named_scope :for_day, lambda { |day|
    { :conditions => {:day => day} }
  }

  validates_presence_of :name, :day, :open_at_hours, :open_at_minutes, :open_at_am_pm, :closed_at_hours, :closed_at_minutes, :closed_at_am_pm
  validates_inclusion_of :day, :in => DAYS

  def open_at
    "#{open_at_hours}:#{open_at_minutes}#{open_at_am_pm}"
  end
  def closed_at
    "#{closed_at_hours}:#{closed_at_minutes}#{closed_at_am_pm}"
  end
end
