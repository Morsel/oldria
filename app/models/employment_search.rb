# == Schema Information
# Schema version: 20120217190417
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
  has_one :media_request

  serialize :conditions

  validates_presence_of :conditions

  before_save :clean_up_conditions
  attr_accessible :conditions
  def employments
    Employment.search(conditions) # searchlogic
  end

  def employment_ids
    employments.map(&:id).uniq
  end

  def restaurant_ids
    employments.all(:group => :restaurant_id).map(&:restaurant_id).uniq
  end
  
  def restaurants
    Restaurant.find(restaurant_ids)
  end

  def solo_employments
    employments.select { |e| e.restaurant.nil? }.uniq
  end
  
  def solo_employment_ids
    solo_employments.map(&:id)
  end

  def readable_conditions_hash
    readable_conditions_hash = {}
    conditions.each do |key,value|
      if key.to_s =~ /(restaurant_)?(.+)_id/
        criteria_name = $2.humanize.titleize
        criteria_class = $2.classify
        criteria_class = "RestaurantRole" if criteria_class == "Role"
        criteria_class = "User" if criteria_class == "Employee"
        # Find the matching objects for the criteria class, and assign to the hash for display
        readable_conditions_hash[criteria_name] = criteria_class.constantize.find([value].flatten).map(&:name).to_sentence rescue
            readable_conditions_hash[criteria_name] = "[not found]"
      end
    end

    readable_conditions_hash
  end

  def readable_conditions
    readable_conditions_hash.inject([]) do |ary, (k,v)|
      ary + ["#{k}: #{v}"]
    end
  end

  def clean_up_conditions
    conditions.each do |k,v|
      v = v.reject(&:blank?) if v.is_a?(Enumerable)
      if v.blank?
        conditions.delete(k)
      else
        conditions[k] = v
      end
    end
  end

  def search_params
    conditions
  end

end
