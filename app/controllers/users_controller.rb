class UsersController < ApplicationController
  before_filter :require_user, :only => [:show]
  before_filter :require_owner_or_admin, :only => [:edit, :update, :remove_twitter, :remove_avatar]

  def show
    if params[:username]
      @user = User.find_by_username(params[:username], :include => [{:followings => :friend}, :followers])
      raise ActiveRecord::RecordNotFound, "Couldn't find User with username=#{params[:username]}" if @user.nil?
    else
      @user = User.find(params[:id], :include => [{:followings => :friend}, :followers])
    end
    @latest_status = @user.statuses.first
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.deliver_signup(@user)
      flash[:notice] = "Please check your email to confirm your account"
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
      flash[:notice] = "Successfully updated your account."
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
      flash[:message] = "Your Headshot was successfully removed"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end


  private

  def require_owner_or_admin
    unless (params[:id] && User.find(params[:id]) == current_user) || current_user.admin?
      flash[:error] = "You are not allowed to view this page."
      redirect_to root_url
    end
  end
  
end
