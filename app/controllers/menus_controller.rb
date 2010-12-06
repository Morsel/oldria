class MenusController < ApplicationController
  before_filter :require_user
  before_filter :require_account_manager_authorization
  before_filter :find_restaurant

  def index
    @menu = Menu.new(:restaurant => @restaurant)
    @menu.pdf_remote_attachment = PdfRemoteAttachment.new
  end

  def create
    @menu = Menu.from_params(params[:menu].merge(:restaurant => @restaurant))
    if @menu.invalid?
      @menu.pdf_remote_attachment = PdfRemoteAttachment.new(params[:menu][:pdf_remote_attachment_attributes])
      render :action => :index
    else
      redirect_to restaurant_menus_path
    end
  end

  def reorder
    Rails.logger.info params[:menu].inspect
    params[:menu].each_with_index do |menu_id, index|
      menu = @restaurant.menus.find(menu_id)
      menu.update_attribute(:position, index + 1)
    end
    Rails.logger.info @restaurant.menus.reload.inspect
    render :text => ""
  end

  def destroy
    Menu.find(params[:id]).destroy
    redirect_to restaurant_menus_path
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id], :include => :menus)
  end
end
