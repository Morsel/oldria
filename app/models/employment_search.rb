class EmploymentSearch < ActiveRecord::Base
  
  has_one :holiday
  
  serialize :conditions
  
  validates_presence_of :conditions
  
end
