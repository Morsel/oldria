class Admin::RestaurantFeaturePagesController < Admin::AdminController

  def create
    @page = RestaurantFeaturePage.new(params[:restaurant_feature_page])
    if @page.save
      flash[:notice] = "Your new page #{@page.name} has been added"
    else
      flash[:error] = "The page #{@page.name} was invalid, it may be a duplicate"
    end
    redirect_to admin_restaurant_features_path
  end

  # sent from the eip javascript function
  # see http://josephscott.org/code/javascript/jquery-edit-in-place/ for
  # parameters
  def edit_in_place
    id = params[:id].split("_")[-1]
    @page = RestaurantFeaturePage.find(id.to_i)
    success = @page.update_attributes(:name => params[:new_value].strip)
    if success
      render :text => {:is_error => false, :error_text => nil, :html => @page.name}.to_json
    else
      render :text => {:is_error => true,
          :error_text => "Error updating page -- possible duplicate",
          :html => @page.name}.to_json
    end
  end

end