class RestaurantFeature < ActiveRecord::Base

  belongs_to :restaurant_feature_category
  alias_attribute :category, :restaurant_feature_category

  validates_presence_of :value
  validates_uniqueness_of :value, :scope => :restaurant_feature_category_id

end