class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    # render
  end

  def create
    @user = User.find_by_email(params[:email])
    @is_mediafeed = params[:mediafeed]
    if @user && @user.confirmed?
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Please check your email for instructions"
      redirect_to mediafeed? ? mediafeed_root_url : root_url
    else
      flash.now[:error] = @user ? "Your account is not confirmed.<br/>Please check your email for instructions or 
          <a href='#{mediafeed? ? mediafeed_resend_user_confirmation_path : resend_confirmation_users_path}'>request the confirmation email</a> again." : 
          "No user was found with that email address"
      render :action => :new, :layout => mediafeed? ? 'mediafeed' : 'application'
    end
  end
  
  def edit
    # render
  end
  
  def update
    @user.password = params[:user][:password] 
    @user.password_confirmation = params[:user][:password_confirmation] 
    if @user.save
      @user.reset_perishable_token!
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
