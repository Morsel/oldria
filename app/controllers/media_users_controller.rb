class MediaUsersController < ApplicationController
  def new
    @media_user = User.new
  end
  
  def create
    @media_user = User.new(params[:user])
    @media_user.account_type = AccountType.find_by_name("Media")
    if @media_user.save
      UserMailer.deliver_signup(@media_user)
      flash[:notice] = "Just to make sure you are who you say you are, we sent you a secret coded message to your email account. Once you check that, we’ll give you your fancy credentials to log on."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @media_user = User.find(params[:id])
  end
  
  def update
    @media_user = User.find(params[:id])
    if @media_user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated media user."
      redirect_to media_user_path(@media_user)
    else
      render :edit
    end
  end
end
