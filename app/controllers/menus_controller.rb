class MenusController < ApplicationController
  before_filter :require_user
  before_filter :find_restaurant
  before_filter :require_account_manager_authorization
  before_filter :find_menu, :only => [:edit, :update]

  def bulk_edit
    @menu = Menu.new(:restaurant => @restaurant)
    @menu.pdf_remote_attachment = PdfRemoteAttachment.new
  end

  def create
    @menu = Menu.new(params[:menu].merge(:restaurant => @restaurant))
    if @menu.save
      redirect_to bulk_edit_restaurant_menus_path(@restaurant)
    else
      # TODO - does this next line actually work? Firefox is not showing the filename in the form when there's an error
      @menu.pdf_remote_attachment = PdfRemoteAttachment.new(params[:menu][:pdf_remote_attachment_attributes])
      render :action => :bulk_edit
    end
  end

  def edit
  end

  def update
    if @menu.update_attributes(params[:menu])
      flash[:success] = "Your changes have been saved."
      redirect_to bulk_edit_restaurant_menus_path(@restaurant)
    else
      @menu.pdf_remote_attachment = PdfRemoteAttachment.new(params[:menu][:pdf_remote_attachment_attributes])
      render :action => :edit
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
    flash[:notice] = "The menu was deleted."
    redirect_to bulk_edit_restaurant_menus_path(@restaurant)
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id], :include => :menus)
  end

  def find_menu
    @menu = @restaurant.menus.find(params[:id])
  end
end
