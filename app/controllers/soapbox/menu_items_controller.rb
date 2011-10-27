class Soapbox::MenuItemsController < ApplicationController
  
  def index
    @menu_items = MenuItem.all(:order => "created_at DESC")
  end

  def show
    @menu_item = MenuItem.find(params[:id])
    @more_menu_items = MenuItem.all(:order => "created_at DESC", :limit => 5, :conditions => ["id != ?", @menu_item.id])
  end

end
