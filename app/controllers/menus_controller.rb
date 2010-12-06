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

  def destroy
    Menu.find(params[:id]).destroy
    redirect_to restaurant_menus_path
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id], :include => :menus)
  end
end
