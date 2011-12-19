class UsersController < ApplicationController

  before_filter :require_visibility, :only => [:show]
  before_filter :require_owner_or_admin, :only => [:edit, :update, :remove_twitter, :remove_avatar,
                                                   :fb_auth, :fb_deauth, :fb_connect, :fb_page_auth]

  def index
    respond_to do |format|
      format.js { auto_complete_employees }
    end
  end

  def show
    # Is the current user following this person?
    @following = current_user.followings.first(:conditions => {:friend_id => @user.id}) if current_user
    @latest_statuses = @user.statuses.all(:limit => 5)
    @responder = @user
  end

  def edit
    redirect_to edit_user_profile_path(:user_id => @user.id)
  end

  def update
    employment_params = params[:user].delete(:default_employment) if params[:user]

    respond_to do |format|
      if @user.update_attributes(params[:user])

        # update default employment
        if employment_params
          if @user.default_employment.present?
            @user.default_employment.update_attributes(employment_params)
          else
            @user.create_default_employment(employment_params)
          end
        end

        format.html do
          flash[:notice] = "Successfully updated your profile."
          redirect_to edit_user_profile_path(:user_id => @user.id)
        end
        format.js   { head :ok }
      else
        @profile = @user.profile || @user.build_profile
        format.html { render :template => 'profiles/edit' }
        format.js   { render :json => @user.errors, :status => :unprocessable_entity }
      end

    end
  end

  def confirm
    @user = User.find_by_perishable_token(params[:id])
    if @user
      @user.confirmed_at = Time.now
      @user_session = UserSession.new(@user)
      if @user_session.save
        @message = "Welcome aboard! Your account has been confirmed."
        redirect_to mediafeed_root_path if @user.media?
      else
        @message = "Could not log you in. Please contact us for assistance."
      end
    elsif current_user
      flash[:notice] = "Looks like you're already set up. Get to work!"
      redirect_to root_path
    else
      flash[:error] = "Oops, looks like that confirmation token has already been used.<br/>Log in below, or click the link to reset your password."
      redirect_to login_path
    end
  end

  def resend_confirmation
    require_no_user unless current_user && current_user.admin?
    @is_mediafeed = params[:mediafeed]
    if request.post?
      if user = User.find_by_email(params[:email])
        UserMailer.deliver_signup user

        if current_user && current_user.admin?
          flash[:notice] = "A confirmation email was just sent to #{user.name}"
          redirect_to admin_users_path
        else
          flash[:notice] = "We just sent you a new confirmation email. Click the link in the email and you'll be ready to go!"
          redirect_to mediafeed? ? mediafeed_root_path : root_path
        end
      else
        flash[:error] = "Sorry, we can't find a user with that email address. Try again?"
        render :layout => (mediafeed? ? 'mediafeed' : 'application')
      end
    end
  end

  def remove_twitter
    @user.atoken  = nil
    @user.asecret = nil
    if @user.save
      flash[:message] = "Your Twitter account is no longer connected to your SpoonFeed account"
      redirect_to edit_user_profile_path(:user_id => @user.id)
    else
      render :edit
    end
  end

  def remove_avatar
    @user.avatar = nil
    if @user.save
      flash[:message] = "Got it! We’ve removed your headshot from your account"
      redirect_to edit_user_profile_path(:user_id => @user.id)
    else
      render :edit
    end
  end

  def fb_auth
  end

  def fb_deauth
    @user.update_attribute(:facebook_access_token, nil)
    flash[:notice] = "Your Facebook account has been disconnected"
    redirect_to params[:restaurant_id].present? ? edit_restaurant_path(params[:restaurant_id]) : edit_user_profile_path(:user_id => @user.id)
  end

  def fb_connect
    if current_facebook_user
      @user.connect_to_facebook_user(current_facebook_user.id)
      if @user.facebook_access_token != current_facebook_user.client.access_token
        @user.update_attribute(:facebook_access_token, current_facebook_user.client.access_token)
      end
      flash[:notice] = "Your Facebook account has been connected to your Spoonfeed account"
    else
      flash[:error] = "We were unable to connect your account. Please try again later."
    end
    redirect_to params[:restaurant_id].present? ? edit_restaurant_path(params[:restaurant_id]) : edit_user_profile_path(:user_id => @user.id)
  end

  def fb_page_auth
    @page = current_facebook_user.accounts.select { |a| a.id == params[:facebook_page] }.first

    if @page
      @user.update_attributes!(:facebook_page_id => @page.id, :facebook_page_token => @page.access_token)
      flash[:notice] = "Added Facebook page #{@page.name} to your account"
    else
      @user.update_attributes!(:facebook_page_id => nil, :facebook_page_token => nil)
      flash[:notice] = "Cleared the Facebook page settings from your account"
    end

    redirect_to edit_user_profile_path(:user_id => @user.id)
  end

  private

  def get_user
    if params[:username]
      @user = User.find_by_username(params[:username], :include => [:followings])
      raise ActiveRecord::RecordNotFound, "Couldn't find User with username=#{params[:username]}" if @user.nil?
    else
      @user = User.find(params[:id], :include => [:followings])
    end
  end

  def owner?
    params[:id] && User.find(params[:id]) == current_user
  end

  def require_owner_or_admin
    get_user
    unauthorized! unless can?(:manage, @user)
  rescue CanCan::AccessDenied
    flash[:error] = "You are not authorized to access this page."
    redirect_to root_path
  end

  def auto_complete_employees
    @users = User.for_autocomplete.find_all_by_name(params[:q]) if params[:q]
    if @users
      render :text => @users.map(&:name).join("\n")
    end
  end

  def require_visibility
    get_user
    unless @user.prefers_publish_profile || current_user
      flash[:error] = "You must be logged in to access this page"
      redirect_to login_path
    end
  end

end
