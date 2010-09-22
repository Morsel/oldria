class Admin::RestaurantFeatureCategoriesController < Admin::AdminController

  def create
    @category = RestaurantFeatureCategory.new(params[:restaurant_feature_category])
    if @category.save
      flash[:notice] = "Your new category #{@category.name} has been added"
    else
      flash[:error] = "The category #{@category.name} was invalid, it may be a duplicate"
    end
    redirect_to admin_restaurant_features_path
  end

end