class MenusController < ApplicationController
  before_filter :find_restaurant

  def index
    @menu = Menu.new(:restaurant => @restaurant)
    @menu.remote_attachment = RemoteAttachment.new
  end

  def create
    @menu = Menu.from_params(params[:menu].merge(:restaurant => @restaurant))
    if @menu.invalid?
      @menu.remote_attachment = RemoteAttachment.new(params[:menu][:remote_attachment_attributes])
      render :action => :index
    else
      redirect_to restaurant_menus_path
    end
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
