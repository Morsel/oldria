class Soapbox::MenuItemsController < ApplicationController
  
  def index
    if params[:keyword].present?
      @menu_items = MenuItem.from_premium_restaurants.all(:joins => { :menu_item_keywords => :otm_keyword },
                                 :conditions => ["otm_keywords.name = ?", params[:keyword]],
                                 :order => "menu_items.created_at DESC")
    else
      @menu_items = MenuItem.from_premium_restaurants.all(:order => "created_at DESC")
    end
  end

  def show
    @menu_item = MenuItem.find(params[:id])
    @more_menu_items = MenuItem.from_premium_restaurants.all(:order => "created_at DESC", :limit => 5, :conditions => ["menu_items.id != ?", @menu_item.id])
  end

end
