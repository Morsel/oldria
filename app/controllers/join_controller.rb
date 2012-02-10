class JoinController < ApplicationController

  def index
  end

  def register
    if params[:role] == "media"
      @user = User.build_media_from_registration(params)
      if @user.save
        @user.reset_perishable_token!
        UserMailer.deliver_signup(@user)
        redirect_to mediafeed_user_confirmation_path
      else
        render :action => "new", :controller => "media_users"
      end
    end
  end

end
