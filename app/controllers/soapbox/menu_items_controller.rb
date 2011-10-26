class Soapbox::MenuItemsController < ApplicationController
  
  def index
    @menu_items = MenuItem.all(:order => "created_at DESC")
    @categories = OtmKeyword.all.group_by(&:category)
  end

end
