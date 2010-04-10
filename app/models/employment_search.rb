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
  
  serialize :conditions
  
  validates_presence_of :conditions

  def employments
    Employment.search(conditions) # searchlogic
  end
  
  def restaurants
    restaurant_ids = employments.all(:group => :restaurant_id).map(&:restaurant_id)
    Restaurant.find(restaurant_ids)
  end
end
