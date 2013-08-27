class Item < ActiveRecord::Base
  has_many :carte_feature_items, :dependent => :destroy
  has_many :restaurant_features, :through => :carte_feature_items
  belongs_to :category

  validates_presence_of :name
  validates_presence_of :restaurant_features
end
