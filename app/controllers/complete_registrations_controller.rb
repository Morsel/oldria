class CompleteRegistrationsController < ApplicationController
  before_filter :require_user

  ##
  # GET /complete_registraion
  def show
    @user = current_user
  end

  ##
  # PUT /complete_registraion
  def update
    @user = current_user
    force_password_reset
    if @user.update_attributes(params[:user])
      flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
      redirect_to root_path
    else
      render :show
    end
  end

  private
  def force_password_reset
    @user.crypted_password = nil
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end
end
