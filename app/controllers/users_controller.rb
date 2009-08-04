class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.deliver_signup(@user)
      flash[:notice] = "Registration successful"
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
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :edit
    end
  end
  
  def confirm
    @user = User.find_by_perishable_token(params[:id])
    @user.update_attributes(:confirmed_at => Time.now)
    @user_session = UserSession.new(@user)
    if @user_session.save
      flash.now[:notice] = "Thanks for Confirming your account. You are now logged in." 
    end
  end
end
