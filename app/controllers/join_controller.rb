class JoinController < ApplicationController

  def index
  end

  def register
    if params[:role] == "media"
      @user = User.new(:first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email])
      @user.username = [@user.first_name, @user.last_name].map(&:downcase).join(".")
      @user.password = @user.password_confirmation = Authlogic::Random.friendly_token
      if @user.save
        @user.has_role! :media
        @user.reset_perishable_token!
        UserMailer.deliver_signup(@user)
        redirect_to mediafeed_user_confirmation_path
      else
        render :action => "new", :controller => "media_users"
      end
    end
  end

end
