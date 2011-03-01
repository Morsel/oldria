class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new(params[:user_session])
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    save_session
  end

  def create_from_facebook
    user = User.find_by_facebook_id(current_facebook_user.id)
    if user
      if user.facebook_access_token != current_facebook_user.client.access_token
        user.update_attribute(:facebook_access_token, current_facebook_user.client.access_token)
      end
      @user_session = UserSession.new(user)
      save_session
    else
      flash[:error] = "We couldn't find a spoonfeed account connected to that Facebook account. Please log with your username and password below, edit your Profile, and connect your Facebook accounts there. Going forward, you can just click the Facebook login connect button."
      redirect_to :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find(params[:id])
    user = @user_session.user
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to user.media? ? mediafeed_root_url : root_url
  end

  protected

  def save_session
    if @user_session.save
      flash[:notice] = "You are now logged in."
      user = @user_session.user

      if user.admin? || user.media? || user.completed_setup?
        redirect_back_or_default
      else
        flash[:notice] += " Please finish setting up your account."
        redirect_to user_details_complete_registration_path
      end
    else
      if @user_session.errors.on_base == "Your account is not confirmed"
        error_message = "Your account is not confirmed.<br/>
        Please check your email for instructions or  <a href='#{params[:mediafeed] ? mediafeed_resend_user_confirmation_path : resend_confirmation_users_path}'>request the confirmation email</a> again."
      elsif @user_session.errors.on(:username) || @user_session.errors.on(:password)
        error_message = "Oops, you entered the wrong username or password.<br/>
        It coulda been a minor error, so just try again&mdash;or, 
        could it be you tried to log into #{params[:mediafeed] ? 'Mediafeed' : 'Spoonfeed'} with your RIA login credentials?"
      else
        error_message = "Sorry, but we couldn't log you in"
      end

      if params[:mediafeed]
        flash[:error] = error_message
        redirect_to mediafeed_login_path
      else
        flash.now[:error] = error_message
        render :new
      end
    end
  end
end
