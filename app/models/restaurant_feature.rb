# == Schema Information
#
# Table name: restaurant_features
#
#  id                             :integer         not null, primary key
#  restaurant_feature_category_id :integer
#  value                          :string(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#

class RestaurantFeature < ActiveRecord::Base

  belongs_to :restaurant_feature_category, :include => :restaurant_feature_page
  has_many :restaurant_feature_items, :dependent => :destroy
  has_many :restaurants, :through => :restaurant_feature_items
  has_many :trace_searches, :as => :keywordable

  validates_presence_of :value
  validates_uniqueness_of :value, :scope => :restaurant_feature_category_id
  attr_accessible :value,:restaurant_feature_category_id, :restaurant_feature_category

  def restaurant_feature_page
    restaurant_feature_category.restaurant_feature_page
  end

  def breadcrumbs
    "#{restaurant_feature_page.name} : #{restaurant_feature_category.name} : #{value}"
  end

  def name
    value
  end

  def deletable?
    restaurants.empty?
  end
  
  def top_tag?(restaurant)
    restaurant_feature_items.find_by_restaurant_id(restaurant.id).top_tag
  end

end
