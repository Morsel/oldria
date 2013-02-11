class Admin::TestRestaurantsController < Admin::AdminController
	before_filter :find_restaurant, :except => :index

  def index
  	@restaurants = Restaurant.only_deleted_restaurants
  end

  def edit
  end

  def active  	
  	@restaurant.update_attribute(:deleted_at, nil)
  	flash[:notice] = "Restaurant has activated."
   	redirect_to edit_admin_restaurant_path(@restaurant)  	
  end	

  private
  

  def find_restaurant
    @restaurant = Restaurant.only_deleted_restaurants.map{|e| e if e.id == 328}.compact.first    
  end
end
