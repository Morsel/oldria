class InvitationsController < ApplicationController
  before_filter :logout_current_user
  before_filter :find_user_from_params

  def show
    if @user
      @user.update_attribute(:confirmed_at, Time.now)
      UserSession.create(@user)
      flash[:notice] = "Successfully logged in. Please take a moment and update your account information."
      redirect_to complete_registration_path
    elsif params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
      if @user.confirmed
        redirect_to login_invitations_path(:user_session => {:username => @user.username})
      else
        flash[:error] = "Something went wrong trying to confirm your account. Please request a new confirmation email below."
        redirect_to resend_confirmation_users_path
      end
    else
      flash[:error] = "We could not locate your account."
      redirect_to login_path, :user_id => params[:user_id]
    end
  end

  def login
    @user_session = UserSession.new(params[:user_session])
  end

  private

  def logout_current_user
    @current_user_session.destroy if current_user_session
  end

  def find_user_from_params
    @user = User.find_using_perishable_token(params[:id])
  end
end
