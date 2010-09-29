class Admin::RestaurantFeaturesController < Admin::AdminController

  def index
    @restaurant_feature_page = RestaurantFeaturePage.new
    @restaurant_feature_category = RestaurantFeatureCategory.new
    @restaurant_feature = RestaurantFeature.new
    @pages = RestaurantFeaturePage.by_name.all(
        :include => {:restaurant_feature_categories => {:restaurant_features => :restaurants}})
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

  # sent from the eip javascript function
  # see http://josephscott.org/code/javascript/jquery-edit-in-place/ for
  # parameters
  def edit_in_place
    id = params[:id].split("_")[-1]
    @feature = RestaurantFeature.find(id.to_i)
    success = @feature.update_attributes(:value => params[:new_value].strip)
    if success
      render :text => {:is_error => false, :error_text => nil, :html => @feature.value}.to_json
    else
      render :text => {:is_error => true,
          :error_text => "Error updating feature -- possible duplicate",
          :html => @feature.value}.to_json
    end
  end

  def destroy
    @feature = RestaurantFeature.find(params[:id])
    @feature.destroy if @feature.deletable?
    redirect_to admin_restaurant_features_path
  end

end