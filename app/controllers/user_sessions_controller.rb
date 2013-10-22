class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create, :create_from_facebook]
  before_filter :require_user_or_subscriber, :only => :destroy

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
      user.update_attribute(:facebook_token_expiration, current_facebook_user.client.expiration)
      if user.facebook_access_token != current_facebook_user.client.access_token
        user.update_attribute(:facebook_access_token, current_facebook_user.client.access_token)
      end
      @user_session = UserSession.new(user)
      save_session
    else
      flash[:error] = "We couldn't find a Spoonfeed account connected to that Facebook account. Please log with your username and password below, edit your profile, and connect your Facebook accounts there. Going forward, you can just click the Facebook login connect button."
      redirect_to :action => 'new'
    end
  end

  def destroy
    # Logout of Spoonfeed
    if current_user
      @user_session = UserSession.find(params[:id])
      user = @user_session.user
      @user_session.destroy
    end

    # Logout of Soapbox
    if current_subscriber
      cookies.delete(:newsletter_subscriber_id)
    end

    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end

  protected

  def save_session
    if @user_session.save
      flash[:notice] = "You are now logged in."
      user = @user_session.user                        
      if user.admin? || user.media? || (user.completed_setup? && !is_profile_not_completed?(user))
        restaurants_has_setup_fb_tw user
        if @restaurants_has_not_setup_fb_tw.blank?
          if user.media? && user.publication.blank? 
            flash.delete(:notice)
            flash[:error] = "You are now logged in and you can add publication."
            redirect_to edit_mediafeed_media_user_path(user)
          else  
            redirect_back_or_default
          end
        else
          #restaurant = user.restaurants.map{|restaurant| restaurant unless restaurant.count.nil? }.compact.first
          #unless restaurant.blank?
           # flash[:notice] = "We are sorry! Something went wrong with your payment for #{restaurant.name}. Click here to update your payment method <a href='/restaurants/#{restaurant.id}/subscription/new' >click here</a> "
            #flash[:notice] = "Last time you are try to upgrade your #{restaurant.name} but payment was not successfully due to some reason. You can upgrade your account by <a href='/restaurants/#{restaurant.id}/subscription/new' >click here</a>"
            #redirect_to edit_restaurant_path(restaurant)
          #else
            flash[:notice] = "<a href='javascript:void(0)' onclick=\"$('html, body').animate({scrollTop: $('#twitter-fieldset').offset().top -50}, 400);\">Get the most out of Spoonfeed. Hook up your Twitter and Facebook accounts with your restaurant today!</a>".html_safe
            redirect_to edit_restaurant_path(@restaurants_has_not_setup_fb_tw.first)
          #end
        end  
      else
        if user.completed_setup? && is_profile_not_completed?(user)
          flash[:notice] += " Complete your profile."
          redirect_to complete_profile_user_profile_path(user)
        else  
          flash[:notice] += " Please finish setting up your account."
          redirect_to user_details_complete_registration_path
        end
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

      flash.now[:error] = error_message
      render :new
    end
  end
end
