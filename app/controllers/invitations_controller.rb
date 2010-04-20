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
      redirect_to login_path
    else
      flash[:error] = "We could not locate your account."
      redirect_to root_url
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
