# == Schema Information
# Schema version: 20100409221445
#
# Table name: employment_searches
#
#  id         :integer         not null, primary key
#  conditions :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EmploymentSearch < ActiveRecord::Base
  has_one :trend_question
  has_one :holiday
  
  serialize :conditions, Hash
  
  validates_presence_of :conditions
  
end
