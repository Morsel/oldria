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
      flash[:notice] = "Please check your email for instructions to finish resetting your password"
      redirect_to :action => "new"
    else
      flash.now[:error] = @user ? "Your account is not confirmed.<br/>Please check your email for instructions or 
          <a href='#{resend_confirmation_users_path}'>request the confirmation email</a> again." : 
          "No user was found with that email address"
      render :action => :new
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

      # Spoonfeed users often begin initial setup through step 1 (setting a new password), log out, forget the password, 
      # and wind up here to reset it. We need to catch that happening so we can ensure they complete step 2 of the setup
      # process, and not just go to the dashboard.
      if @user.admin? || @user.media? || @user.completed_setup?
        redirect_to root_path
      else
        flash[:notice] += ". Please finish setting up your account."
        redirect_to user_details_complete_registration_path
      end
    else
      render :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "Oops. We're having trouble finding your account."
      redirect_to :action => "new"
    end
  end

end
