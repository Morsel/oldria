class Admin::RestaurantsController < Admin::AdminController
  before_filter :find_restaurant, :except => [:index,:invalid_employments]

  def index
    @restaurants = Restaurant.find(:all, :include => [:manager, :cuisine], :order => :sort_name)
  end

  def edit
  end

  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to admin_restaurants_path
    else
      flash[:error] = "We were unable to update the restaurant"
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    flash[:notice] = "Successfully removed restaurant"
    respond_to do |format|
      format.html { redirect_to admin_restaurants_path }
      format.js   { render :text => '' }
    end
  end

  def upload_photo
    @restaurant.photos << Photo.create!(params[:image])
    @restaurant.update_attributes!(:primary_photo => @restaurant.photos.last) unless @restaurant.primary_photo
    redirect_to edit_photos_admin_restaurant_path(@restaurant)
  end

  def upload_logo
    @restaurant.update_attributes!(:logo => Image.create!(params[:logo]))
    redirect_to edit_admin_restaurant_path(@restaurant)
  end

  def select_primary_photo
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to bulk_edit_restaurant_photos_path(@restaurant)
    else
      flash[:error] = "We were unable to update the restaurant"
      #render :edit_photos
      redirect_to bulk_edit_restaurant_photos_path(@restaurant)
    end
    
  end

  def edit_photos
  end
  def invalid_employments
    @employments = []
    Restaurant.all.each do |e| 
      e.employments.map{|emp| @employments << emp unless emp.valid? }
    end
  end   
  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
