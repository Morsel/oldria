class CompleteRegistrationsController < ApplicationController
  
  before_filter :require_user

  ##
  # GET /complete_registration
  def show
    @user = current_user
  end

  ##
  # PUT /complete_registration
  def update
    @user = User.find(params[:user].delete(:id))
    force_password_reset unless params[:step] == '2'
    if @user.update_attributes(params[:user])
      @user.reset_perishable_token! unless params[:step] == '2'
      if @user.primary_employment.present?
        
        # if restaurant name matches an existing one, go to the find_restaurant workflow
        if @user.primary_employment.solo_restaurant_name.present? && 
            Restaurant.exists?(["name like ?", "%#{@user.primary_employment.solo_restaurant_name}%"])
          redirect_to :action => "find_restaurant", :restaurant_name => @user.primary_employment.solo_restaurant_name
        else
          flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
          redirect_to(root_path)
        end
        
      else
        redirect_to(:action => "user_details")
      end
    else
      render :show
    end
  end
  
  def user_details
    @user = current_user
    solo_restaurant_name = @user.invitation.restaurant_id ? 
        Restaurant.find(@user.invitation.restaurant_id).name :
        @user.invitation.restaurant_name
    @user.build_default_employment(:solo_restaurant_name => solo_restaurant_name)
    @user.build_profile
  end
  
  def find_restaurant
    if params[:restaurant_name]
      @restaurants = Restaurant.find(:all, :conditions => ["name like ?", "%#{params[:restaurant_name]}%"])
    end
  end
  
  def contact_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    if @restaurant
      UserMailer.deliver_employee_request(@restaurant, current_user)
      flash[:notice] = "We've contacted the restaurant manager. Thanks for setting up your account, and enjoy SpoonFeed!"
      redirect_to root_path
    end
  end
  
  def finish_without_contact
    flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
    redirect_to root_path
  end

  private
  
  def force_password_reset
    return unless params[:user]
    @user.crypted_password = nil
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end
  
end
