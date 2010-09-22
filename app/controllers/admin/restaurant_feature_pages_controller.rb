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

end