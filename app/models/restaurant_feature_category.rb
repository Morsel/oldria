class RestaurantFeatureCategory < ActiveRecord::Base
  has_many :restaurant_features

  belongs_to :restaurant_feature_page

  validates_presence_of :name
  validates_uniqueness_of :name

  named_scope :by_name, :order => "name ASC"

  def deletable?
    restaurant_features.empty?
  end
end