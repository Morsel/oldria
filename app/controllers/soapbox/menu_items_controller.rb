class Soapbox::MenuItemsController < ApplicationController
  
  before_filter :verify_restaurant_activation, :only =>[:show]

  def index    
    if params[:keyword].present?
      @menu_items = MenuItem.from_premium_restaurants.all(:joins => { :menu_item_keywords => :otm_keyword },
                                 :conditions=> ["otm_keywords.name = ?", params[:keyword]],
                                 :order => "menu_items.created_at DESC")
    elsif params[:restaurant_id].present?
      @restaurant = Restaurant.activated_restaurant.find(:first,:conditions=> ["id = ?",params[:restaurant_id]])
      @menu_items = @restaurant.menu_items.all(:order => "created_at DESC") if !@restaurant.nil?
    else
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC")
    end      
      @menu_items = @menu_items.paginate(:page => params[:page], :per_page => 5)  unless @menu_items.count < 1
  end

  def show        
  end

   def verify_restaurant_activation        
      @menu_item = MenuItem.find(params[:id])       
      unless @menu_item.restaurant.is_activated?        
        flash[:error] = "This on the Menu page is unavailable."
        redirect_to :soapbox_menu_items   
      end
  end

end
