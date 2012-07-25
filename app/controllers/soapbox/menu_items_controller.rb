class Soapbox::MenuItemsController < ApplicationController
  
  def index    
    if params[:keyword].present?
      @menu_items = MenuItem.from_premium_restaurants.all(:joins => { :menu_item_keywords => :otm_keyword },
                                 :conditionsz => ["otm_keywords.name = ?", params[:keyword]],
                                 :order => "menu_items.created_at DESC")
    elsif params[:restaurant_id].present?
      @restaurant = Restaurant.activated_restaurant.find(:first,:conditions=> ["id = ?",params[:restaurant_id]])
      @menu_items = @restaurant.menu_items.all(:order => "created_at DESC") if !@restaurant.nil?
    else
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC")
    end  
    debugger  
      @menu_items = @menu_items.paginate(:page => params[:page], :per_page => 5)  unless @menu_items.count < 1
    
  end

  def show        
    @menu_item = MenuItem.activated_restaurants.find(:first,:conditions=>["menu_items.id= ?",params[:id]]) 
    if(@menu_item.nil?)
        flash[:notice] = "Restaurant not found or deactivated."
        redirect_back_or_default #redirect_to(:back) // can be used redirect back
    else      
      @more_menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC", :limit => 5, :conditions => ["menu_items.id != ? and menu_items.created_at >= ?", @menu_item.id,  (Date.today-7) ])
    end 
  end

end
