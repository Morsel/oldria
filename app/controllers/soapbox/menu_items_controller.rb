class Soapbox::MenuItemsController < ApplicationController
  
  def index
    if params[:keyword].present?
      @menu_items = MenuItem.from_premium_restaurants.all(:joins => { :menu_item_keywords => :otm_keyword },
                                 :conditions => ["otm_keywords.name = ?", params[:keyword]],
                                 :order => "menu_items.created_at DESC")
    elsif params[:restaurant_id].present?
      @restaurant = Restaurant.find(params[:restaurant_id])
      @menu_items = @restaurant.menu_items.all(:order => "created_at DESC")
    else
      @menu_items = MenuItem.from_premium_restaurants.all(:order => "created_at DESC")
    end
    @menu_items = @menu_items.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @menu_item = MenuItem.find(params[:id])
    @more_menu_items = MenuItem.from_premium_restaurants.all(:order => "created_at DESC", :limit => 5, :conditions => ["menu_items.id != ?", @menu_item.id])
  end

end
