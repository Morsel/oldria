# == Schema Information
# Schema version: 20120501172145
#
# Table name: restaurant_feature_items
#
#  restaurant_id         :integer
#  restaurant_feature_id :integer
#  id                    :integer         not null, primary key
#  top_tag               :boolean
#

class RestaurantFeatureItem < ActiveRecord::Base
  
  belongs_to :restaurant
  belongs_to :restaurant_feature

end

