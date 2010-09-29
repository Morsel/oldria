class MenusController < ApplicationController
  before_filter :find_restaurant

  def index
    @menu = Menu.new(:restaurant => @restaurant)
  end

  def create
    Menu.from_params!(params[:menu].merge(:restaurant => @restaurant))
    redirect_to restaurant_menus_path
  end

  def destroy
    Menu.find(params[:id]).destroy
    redirect_to restaurant_menus_path
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
