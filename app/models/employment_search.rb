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

  def readable_conditions_hash
    readable_conditions_hash = {}
    conditions.each do |key,value|
      if key.to_s =~ /(restaurant_)?(.+)_id_eq$/
        criteria_name = $2.humanize.titleize
        criteria_class = $2.classify
        criteria_class = "RestaurantRole" if criteria_class == "Role"
        readable_conditions_hash[criteria_name] = criteria_class.constantize.find(value).try(:name)
      end
    end
    readable_conditions_hash
  end

  def readable_conditions
    readable_conditions_hash.inject([]) do |ary, (k,v)|
      ary + ["#{k}: #{v}"]
    end
  end
end
