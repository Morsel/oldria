class RestaurantFeature < ActiveRecord::Base

  belongs_to :restaurant_feature_category, :include => :restaurant_feature_page

  validates_presence_of :value
  validates_uniqueness_of :value, :scope => :restaurant_feature_category_id

  def restaurant_feature_page
    restaurant_feature_category.restaurant_feature_page
  end

  def breadcrumbs
    "#{restaurant_feature_page.name} : #{restaurant_feature_category.name} : #{value}"
  end

end