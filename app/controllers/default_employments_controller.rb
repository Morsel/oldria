class DefaultEmploymentsController < ApplicationController
  
  before_filter :require_user

  def new
    @employment = DefaultEmployment.new
  end
  
  def create
    @user = User.find(params[:user_id])
    @employment = @user.build_default_employment(params[:default_employment])
    if @employment.save
      flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
      redirect_to root_path
    else
      render :action => "new"
    end
  end
  
end
