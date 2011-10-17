class MenuItemsController < ApplicationController

  before_filter :require_user
  before_filter :require_manager

  def index
    @menu_item = MenuItem.new
    @menu_items = @restaurant.menu_items
  end

  def create
    @menu_item = @restaurant.menu_items.build(params[:menu_item])
    if @menu_item.save
      flash[:notice] = "Your menu item has been saved"
      redirect_to :action => "index"
    else
      render :action => "index"
    end
  end

  def edit
  end

  def destroy
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def require_manager
    find_restaurant
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end

end
