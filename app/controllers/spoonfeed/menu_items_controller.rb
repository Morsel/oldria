class Spoonfeed::MenuItemsController < ApplicationController

  before_filter :require_user
  before_filter :verify_restaurant_activation, :only =>[:show]

  def index

    if params[:keyword].present?
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:joins => { :menu_item_keywords => :otm_keyword },
                                 :conditions => ["otm_keywords.name = ?", params[:keyword]],
                                 :order => "menu_items.created_at DESC")

      @keywordable_id =  params[:id]
      @keywordable_type = 'OtmKeyword' 
     else
      @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC")
    end    
      
    @menu_items = @menu_items.paginate(:page => params[:page], :per_page => 5) unless @menu_items.count < 1

  end

  def show
    @menu_item = MenuItem.find(:first,:conditions=>["menu_items.id= ?",params[:id]]) 
    @restaurant = @menu_item.restaurant   
  end

  def verify_restaurant_activation        
      @menu_item = MenuItem.find(params[:id])       
      unless @menu_item.restaurant.is_activated?        
        flash[:error] = "This on the Menu page is unavailable."
        redirect_to :menu_items   
      end
  end

end
