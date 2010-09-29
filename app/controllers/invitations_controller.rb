class InvitationsController < ApplicationController
  before_filter :find_user_from_params, :only => [:show]
  
  def new
    if params[:invitation]
      @invitation = current_user ? 
        Invitation.new(params[:invitation].merge(:requesting_user_id => current_user.id)) : 
        Invitation.new(params[:invitation])
    else
      @invitation = current_user ? Invitation.new(:requesting_user_id => current_user.id) : Invitation.new
    end
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    if @invitation.save
      flash[:notice] = "Your invite has been sent to an admin for approval"
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    if @user
      logout_current_user
      @user.confirm! unless @user.confirmed?
      UserSession.create(@user)
      flash[:notice] = "Successfully logged in. Please take a moment and update your account information."
      redirect_to complete_registration_path
    elsif params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
      if @user.confirmed
        flash[:notice] = "Cool! It looks like you're already set up for SpoonFeed.<br/>Log in below to start having fun!"
        redirect_to login_path(:user_session => {:username => @user.username})
      else
        flash[:error] = "Something went wrong trying to confirm your account. Please request a new confirmation email below."
        redirect_to resend_confirmation_users_path
      end
    else
      flash[:error] = "We could not locate your account."
      redirect_to login_path, :user_id => params[:user_id]
    end
  end

  private

  def logout_current_user
    @current_user_session.destroy if current_user_session
  end

  def find_user_from_params
    @user = User.find_using_perishable_token(params[:id])
  end
end
