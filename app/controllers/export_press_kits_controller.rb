class ExportPressKitsController < ApplicationController
  before_filter :find_restaurant

  def new
  end  

  def create
    @restaurant =  Restaurant.find(params[:restaurant])  
    @employments = @restaurant.employments.by_position.all(
        :include => [:subject_matters, :restaurant_role, :employee])
    @questions = ALaMinuteAnswer.public_profile_for(@restaurant)[0...3]
    @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 5)
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
    @trend_answer = @restaurant.admin_discussions.for_trends.with_replies.first(:order => "created_at DESC")  
    if params[:export_type] == "Diner"
      if !params[:email].blank? && !current_user.blank?
	      UserMailer.deliver_export_press_kit(params[:email],current_user,@restaurant)
      end
    elsif params[:export_type] == "Media"
      if !params[:email].blank? && !current_user.blank?
        UserMailer.deliver_export_press_kit_for_media(params[:email],current_user,@restaurant,@employments,@menu_items,@promotions)
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
