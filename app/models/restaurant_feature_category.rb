class RestaurantFeatureCategory < ActiveRecord::Base
  has_many :restaurant_features
  alias_attribute :features, :restaurant_features

  belongs_to :restaurant_feature_page
  alias_attribute :page, :restaurant_feature_page

  validates_presence_of :name
  validates_uniqueness_of :name

  named_scope :by_name, :order => "name ASC"
end