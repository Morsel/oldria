class RestaurantFeaturePage < ActiveRecord::Base
  has_many :restaurant_feature_categories
  alias_attribute :categories, :restaurant_feature_categories

  validates_presence_of :name
  validates_uniqueness_of :name

  named_scope :by_name, :order => "name ASC"
end