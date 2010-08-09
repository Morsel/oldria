# == Schema Information
# Schema version: 20100809212429
#
# Table name: question_roles
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  restaurant_role_ids :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class QuestionRole < ActiveRecord::Base

  validates_presence_of :name

  serialize :restaurant_role_ids
  
  def restaurant_roles
    RestaurantRole.find(restaurant_role_ids.reject { |r| r.blank? })
  end
  
end
