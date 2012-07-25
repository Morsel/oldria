class Spoonfeed::MenuItemsController < ApplicationController

  before_filter :require_user

  def index
    
    if params[:keyword].present?
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:joins => { :menu_item_keywords => :otm_keyword },
                                 :conditions => ["otm_keywords.name = ?", params[:keyword]],
                                 :order => "menu_items.created_at DESC")
    else
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC")
    end    
      
    @menu_items = @menu_items.paginate(:page => params[:page], :per_page => 5) unless @menu_items.count < 1
      
    
    
  end

  def show
    @menu_item = MenuItem.activated_restaurants.find(:first,:conditions=>["menu_items.id= ?",params[:id]]) 

    if(@menu_item.nil?)
        flash[:notice] = "Restaurant not found or deactivated."
        redirect_back_or_default #redirect_to(:back) // can be used redirect back
    else      
      @restaurant = @menu_item.restaurant
    end 
  end

end
