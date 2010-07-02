class Event < ActiveRecord::Base
  
  CATEGORIES = ['Charity', 'Holiday', 'Private', 'Promotion', 'Other']
  
  belongs_to :restaurant
  
  validates_presence_of :title, :start_at, :end_at, :location, :category
  
  named_scope :for_month_of, lambda { |date| 
    { :conditions => { :start_at => date.beginning_of_month.at_midnight..date.end_of_month.end_of_day } } 
  }
  
  named_scope :by_category, lambda { |category|
    { :conditions => { :category => category } }
  }
  
  def date
    start_at
  end
  
end
