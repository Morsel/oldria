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
        UserMailer.deliver_employee_request(@user.primary_employment.restaurant, @user) if @user.primary_employment.restaurant
        
        flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
        redirect_to(root_path)
      else
        redirect_to(:action => "user_details")
      end
    else
      render :show
    end
  end
  
  def user_details
    @user = current_user
    @user.build_profile
    @user.build_default_employment
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

  private
  
  def force_password_reset
    return unless params[:user]
    @user.crypted_password = nil
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end
  
end
