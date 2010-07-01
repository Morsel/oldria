class Event < ActiveRecord::Base
  
  belongs_to :restaurant
  
  validates_presence_of :title, :start_at, :end_at, :location
  
  named_scope :for_month_of, lambda { |date| 
    { :conditions => { :start_at => date.beginning_of_month.at_midnight..date.end_of_month.end_of_day } } 
  }
  
  def date
    start_at
  end
  
end
