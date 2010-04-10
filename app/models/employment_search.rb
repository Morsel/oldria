class EmploymentSearch < ActiveRecord::Base
  
  has_one :holiday
  
  serialize :conditions, Hash
  
  validates_presence_of :conditions
  
end
