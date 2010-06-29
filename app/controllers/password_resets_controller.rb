class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    # render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.confirmed?
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Please check your email for instructions"
      redirect_to root_url
    else
      flash.now[:error] = @user ? "Your account is not confirmed.<br/>Please check your email for instructions or 
          <a href='#{resend_confirmation_users_path}'>click here</a> to request the confirmation email again." : 
          "No user was found with that email address"
      render :new
    end
  end
  
  def edit
    # render
  end
  
  def update
    @user.password = params[:user][:password] 
    @user.password_confirmation = params[:user][:password_confirmation] 
    if @user.save 
      flash[:notice] = "Password successfully updated"
      redirect_to root_url
    else
      render :edit
    end
  end

private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "Oops. We're having trouble finding your account."
      redirect_to root_url
    end
  end

end
