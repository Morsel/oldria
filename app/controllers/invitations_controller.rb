class InvitationsController < ApplicationController
  def show
    if @user = User.find_using_perishable_token(params[:id])
      @user.update_attribute(:confirmed_at, Time.now)
      @user_session = UserSession.create(@user)
      flash[:notice] = "Successfully logged in. Please take a moment and update your account information."
    else
      flash[:error] = "We could not locate your account."
      redirect_to root_url
    end
  end
end
