# == Schema Information
# Schema version: 20100412193718
#
# Table name: employment_searches
#
#  id         :integer         not null, primary key
#  conditions :text
#  created_at :datetime
#  updated_at :datetime
#

class EmploymentSearch < ActiveRecord::Base
  has_one :trend_question
  has_one :content_request
  has_one :holiday

  serialize :conditions

  validates_presence_of :conditions

  def employments
    Employment.search(conditions) # searchlogic
  end

  def restaurants
    Restaurant.find(restaurant_ids)
  end

  def restaurant_ids
    employments.all(:group => :restaurant_id).map(&:restaurant_id).uniq
  end
end
