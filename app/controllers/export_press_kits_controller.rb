class ExportPressKitsController < ApplicationController
  before_filter :find_restaurant

  def new
  end  

  def create
    @restaurant =  Restaurant.find(params[:restaurant])  
    if params[:export_type] == "Diner"
      if !params[:email].blank? && !current_user.blank?
	      UserMailer.deliver_export_press_kit(params[:email],current_user,@restaurant)
      end
    elsif params[:export_type] == "Media"
      if !params[:email].blank? && !current_user.blank?
        UserMailer.deliver_export_press_kit_for_media(params[:email],current_user,@restaurant)
      end    
	  end	
	  flash[:notice] = "Your press kit has been sent successfully!"
	  redirect_to :action => "new"  
  end



 private

  def find_restaurant
    @user = User.find(params[:user_id])
  	@restaurants = @user.restaurants
  	
  end
end
