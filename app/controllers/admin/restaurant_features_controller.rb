class Admin::RestaurantFeaturesController < Admin::AdminController

  def index
    @restaurant_feature_page = RestaurantFeaturePage.new
    @restaurant_feature_category = RestaurantFeatureCategory.new
    @restaurant_feature = RestaurantFeature.new
    @pages = RestaurantFeaturePage.by_name.all(
        :include => {:restaurant_feature_categories => :restaurant_features})
  end

  def create
    @feature = RestaurantFeature.new(params[:restaurant_feature])
    if @feature.save
      flash[:notice] = "Your new feature #{@feature.value} has been added"
    else
      flash[:error] = "The category #{@feature.value} was invalid, it may be a duplicate"
    end
    redirect_to admin_restaurant_features_path
  end

end