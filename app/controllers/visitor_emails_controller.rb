class VisitorEmailsController < ApplicationController
	before_filter :require_user
	before_filter :authorize
	before_filter :find_restaurant

  def edit
    @restaurant.build_visitor_email_setting.save if @restaurant.visitor_email_setting.blank?
  	@visitor_email_setting = @restaurant.visitor_email_setting
  end

  def update
    if @restaurant.visitor_email_setting.update_attributes(params[:visitor_email_setting])
      flash.now[:notice] = "Setting saved!"
      redirect_to :action =>:edit
    else
      flash.now[:error] = "Setting not saved!"
      render :edit
    end  
  end  

  private

  def find_restaurant
  	@restaurant = Restaurant.find(params[:restaurant_id])
  end	

  def authorize
    find_restaurant
    if (cannot? :edit, @restaurant) || (cannot? :update, @restaurant)
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant and return
    end
  end
end
