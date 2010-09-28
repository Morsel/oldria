class MenusController < ApplicationController
  before_filter :find_restaurant

  def index
    @menu = Menu.new(:restaurant => @restaurant)
  end

  def create
    Menu.from_params!(params[:menu])
    redirect_to :action => :index
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
