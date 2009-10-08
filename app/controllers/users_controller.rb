class UsersController < ApplicationController
  access_control :only => [:show, :new], :as_method => :acl do
    deny :medias
    allow all
    deny logged_in, :to => :new
  end

  before_filter :require_user, :only => [:show]
  before_filter :require_owner_or_admin, :only => [:edit, :update, :remove_twitter, :remove_avatar]
  before_filter :acl

  def show
    get_user
    # Is the current user following this person?
    @following = current_user.friends.first(:conditions => {:id => @user.id})
    @latest_statuses = @user.statuses.all(:limit => 3)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.deliver_signup(@user)
      flash[:notice] = "Just to make sure you are who you say you are, we sent you a secret coded message to your email account. Once you check that, we’ll give you your fancy credentials to log on."
      redirect_to '/'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated your profile."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def confirm
    @user = User.find_by_perishable_token(params[:id])
    if @user
      @user.confirmed_at = Time.now
      @user_session = UserSession.new(@user)
      if @user_session.save
        @message = "Welcome aboard! Your account has been confirmed." 
      end
    else
      @message = "Oops, we couldn't find your account. Have you already confirmed your account?"
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
    unless (params[:id] && User.find(params[:id]) == current_user) || current_user.admin?
      flash[:error] = "This is an administrative area. Nothing exciting here at all."
      redirect_to root_url
    end
  end
  
end
