class JoinController < ApplicationController

  def index
  end

  def register
    if params[:role] == "media"
      @user = User.build_media_from_registration(params)
      if @user.save
        @user.reset_perishable_token!
        UserMailer.signup(@user).deliver
        redirect_to confirm_mediafeed_media_user_path(@user)
      else
        get_newsletter_data
        render :template => "mediafeed/media_users/new"
      end
    elsif params[:role] == "restaurant"
      @invitation = Invitation.build_from_registration(params)
      if @invitation.save
        redirect_to confirm_invitation_path(@invitation)
      else
        render :template => "invitations/new"
      end
    elsif params[:role] == "diner"
      @subscriber = NewsletterSubscriber.build_from_registration(params)
      if @subscriber.save
        redirect_to welcome_soapbox_newsletter_subscriber_path(@subscriber)
      else
        render :template => "soapbox/newsletter_subscribers/new"
      end
    else
      flash[:error] = "Please try again."
      redirect_to :action => "index"
    end
  end

  def soapbox_join 
    render :template => "soapbox/join_us"
  end  

  def  soapbox_register
    if params[:role] == "media"
      @user = User.build_media_from_registration(params)
      if @user.save
        @user.reset_perishable_token!
        UserMailer.signup(@user).deliver
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
    elsif params[:role] == "diner"
      @subscriber = NewsletterSubscriber.build_from_registration(params)
      if @subscriber.save
        redirect_to welcome_soapbox_newsletter_subscriber_path(@subscriber)
      else
        render :template => "soapbox/newsletter_subscribers/new"
      end
    else
      flash[:error] = "Please try again."
      render :template => "soapbox/join_us"
    end
  end


end
