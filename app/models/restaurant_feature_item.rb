# == Schema Information
# Schema version: 20120217190417
#
# Table name: restaurant_feature_items
#
#  restaurant_id         :integer
#  restaurant_feature_id :integer
#  id                    :integer         not null, primary key
#  top_tag               :boolean         default(FALSE)
#
# Indexes
#
#  _restaurant_id_restaurant_feature_id_index  (restaurant_id,restaurant_feature_id)
#  restaurant_id_index                         (restaurant_id)
#  restaurant_feature_id_index                 (restaurant_feature_id)
#

class RestaurantFeatureItem < ActiveRecord::Base
  
  belongs_to :restaurant
  belongs_to :restaurant_feature

end

