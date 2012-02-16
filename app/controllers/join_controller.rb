class JoinController < ApplicationController

  def index
  end

  def register
    # TODO - implement form error checking

    if params[:role] == "media"
      @user = User.build_media_from_registration(params)
      if @user.save
        @user.reset_perishable_token!
        UserMailer.deliver_signup(@user)
        redirect_to confirm_mediafeed_media_user_path(@user)
      else
        render :template => "mediafeed/media_users/new"
      end
    elsif params[:role] == "restaurant"
      @invitation = Invitation.build_from_registration(params)
      if @invitation.save
        redirect_to confirm_invitation_path(@invitation)
      else
        render :template => "invitations/new"
      end
    end
  end

end
