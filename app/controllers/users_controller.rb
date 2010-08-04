class UsersController < ApplicationController
  before_filter :require_user, :only => [:show]
  before_filter :require_no_user, :only => [:new]
  before_filter :require_owner_or_admin, :only => [:edit, :update, :remove_twitter, :remove_avatar, :fb_auth, :fb_connect, :fb_page_auth]
  before_filter :block_media, :only => [:new]

  def index
    respond_to do |format|
      format.js { auto_complete_employees }
    end
  end

  def show
    get_user
    # Is the current user following this person?
    @following = current_user.followings.first(:conditions => {:friend_id => @user.id})
    @latest_statuses = @user.statuses.all(:limit => 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.deliver_signup @user
      flash[:notice] = "Just to make sure you are who you say you are, we sent you a secret coded message to your email account. Once you check that, we’ll give you your fancy credentials to log on."
      redirect_to '/'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @fb_user = current_facebook_user.fetch if current_facebook_user && @user.facebook_authorized?
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html do
          flash[:notice] = "Successfully updated your profile."
          redirect_to user_path(@user)
        end
        format.js   { head :ok }
      else
        format.html { render :edit }
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
    if request.post?
      if user = User.find_by_email(params[:email])
        UserMailer.deliver_signup user
        flash[:notice] = "We just sent you a new confirmation email. Click the link in the email and you'll be ready to go!"
        redirect_to root_path
      else
        flash[:error] = "Sorry, we can't find a user with that email address. Try again?"
      end
    end
  end

  def remove_twitter
    @user = User.find(params[:id])
    @user.atoken  = nil
    @user.asecret = nil
    if @user.save
      flash[:message] = "Your Twitter Account was disassociated with your SpoonFeed Account"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def remove_avatar
    @user = User.find(params[:id])
    @user.avatar = nil
    if @user.save
      flash[:message] = "Got it! We’ve removed your headshot from your account"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def fb_auth
    @user = User.find(params[:id])
  end
  
  def fb_deauth
    @user = User.find(params[:id])
    @user.update_attribute(:facebook_access_token, nil)
    flash[:notice] = "Your Facebook account has been disconnected"
    redirect_to :action => "edit", :id => @user.id    
  end
  
  def fb_connect
    @user = User.find(params[:id])
    if current_facebook_user
      @user.connect_to_facebook_user(current_facebook_user.id)
      if @user.facebook_access_token != current_facebook_user.client.access_token
        @user.update_attribute(:facebook_access_token, current_facebook_user.client.access_token)
      end
      flash[:notice] = "Your Facebook account has been connected to your spoonfeed account"
    end
    redirect_to :action => "edit", :id => @user.id
  end
  
  def fb_page_auth
    @user = User.find(params[:id])
    @page = current_facebook_user.accounts.select { |a| a.id == params[:facebook_page] }.first
    @user.update_attributes(:facebook_page_id => @page.id, :facebook_page_token => @page.access_token)
    flash[:notice] = "Added Facebook page #{@page.name} to your account"
    redirect_to :action => "edit", :id => @user.id
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

  def block_media
    if current_user && current_user.media?
      flash[:error] = "This is an administrative area. Nothing exciting here at all."
      redirect_to root_url
    end
  end

  def require_owner_or_admin
    unless (params[:id] && User.find(params[:id]) == current_user) || current_user.admin?
      flash[:error] = "This is an administrative area. Nothing exciting here at all."
      redirect_to root_url
    end
  end

  def auto_complete_employees
    @users = User.for_autocomplete.find_all_by_name(params[:q]) if params[:q]
    if @users
      render :text => @users.map(&:name).join("\n")
    end
  end

end
