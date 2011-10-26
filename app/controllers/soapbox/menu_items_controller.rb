class Soapbox::MenuItemsController < ApplicationController
  
  def index
    @menu_items = MenuItem.all
    @categories = OtmKeyword.all.group_by(&:category)
  end

end
