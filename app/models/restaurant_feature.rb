class RestaurantFeature < ActiveRecord::Base

  belongs_to :restaurant_feature_category, :include => :restaurant_feature_page
  has_and_belongs_to_many :restaurants

  validates_presence_of :value
  validates_uniqueness_of :value, :scope => :restaurant_feature_category_id

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

end
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

