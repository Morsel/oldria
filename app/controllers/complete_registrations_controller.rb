class CompleteRegistrationsController < ApplicationController
  before_filter :require_user

  ##
  # GET /complete_registraion
  def show
    @user = current_user
    @user.password = @user.password_confirmation = ""
  end

  ##
  # PUT /complete_registraion
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
      redirect_to root_path
    else
      render :show
    end
  end
end
