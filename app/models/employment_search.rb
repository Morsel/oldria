class EmploymentSearch < ActiveRecord::Base
  
  has_one :holiday
  
  serialize :conditions
  
end
