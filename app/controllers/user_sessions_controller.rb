class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "You are now logged in."
      redirect_back_or_default
    else
      if @user_session.errors.on_base == "Your account is not confirmed"
        error_message = "Your account is not confirmed.<br/>
Please check your email for instructions or <a href='#{resend_confirmation_users_path}'>click here</a> to request the confirmation email again."
      else
        error_message = "Sorry, but we couldn't log you in"
      end
      flash.now[:error] = error_message
      render :new
    end
  end
  
  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end
