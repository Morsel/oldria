class Spoonfeed::MenuItemsController < ApplicationController

  before_filter :require_user

  def index
    @menu_items = MenuItem.from_premium_restaurants.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

end
