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

    # sent from the eip javascript function
  # see http://josephscott.org/code/javascript/jquery-edit-in-place/ for
  # parameters
  def edit_in_place
    id = params[:id].split("_")[-1]
    @category = RestaurantFeatureCategory.find(id.to_i)
    success = @category.update_attributes(:name => params[:new_value].strip)
    if success
      render :text => {:is_error => false, :error_text => nil, :html => @category.name}.to_json
    else
      render :text => {:is_error => true,
          :error_text => "Error updating category -- possible duplicate",
          :html => @category.name}.to_json
    end
  end

end