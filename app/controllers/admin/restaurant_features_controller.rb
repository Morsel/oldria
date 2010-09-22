class Admin::RestaurantFeaturesController < Admin::AdminController

  def index
    @restaurant_feature_page = RestaurantFeaturePage.new
    @restaurant_feature_category = RestaurantFeatureCategory.new
    @pages = RestaurantFeaturePage.by_name.all(
        :include => {:restaurant_feature_categories => :restaurant_features})
  end

end