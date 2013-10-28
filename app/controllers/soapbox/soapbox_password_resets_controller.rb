class Soapbox::SoapboxPasswordResetsController < ApplicationController
	before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    # render
  end

  def create
    @newsletter_subscriber = NewsletterSubscriber.find_by_email(params[:email])
    if @newsletter_subscriber && @newsletter_subscriber.confirmed?
       @newsletter_subscriber.deliver_soapbox_password_reset_instructions!
      flash[:notice] = "Please check your email for instructions to finish resetting your password"
      redirect_to :action => "new"
    else
       flash.now[:error] = @newsletter_subscriber ? "Your account is not confirmed.<br/>Please check your email for instructions or 
          <a href='#{resend_confirmation_soapbox_soapbox_password_resets_path}'>request the confirmation email</a> again." : 
          "No user was found with that email address"
       render :action => "new"
    end
  end
  
  def edit
    # render
  end
  
  def update
    @newsletter_subscriber.password = params[:newsletter_subscriber][:password]
    @newsletter_subscriber.password_confirmation = params[:newsletter_subscriber][:password_confirmation] 
    if @newsletter_subscriber.save
      @newsletter_subscriber.reset_perishable_token!
      flash[:notice] = "Password successfully updated"
      redirect_to find_subscriber_soapbox_newsletter_subscribers_path
    else
      render :edit
    end
  end


  def resend_confirmation
    if request.post?
      if newsletter_subscriber = NewsletterSubscriber.find_by_email(params[:email])
        UserMailer.signup_for_soapbox(newsletter_subscriber).deliver

        if current_user && current_user.admin?
          flash[:notice] = "A confirmation email was just sent to #{user.name}"
          redirect_to admin_users_path
        else
          flash[:notice] = "We just sent you a new confirmation email. Click the link in the email and you'll be ready to go!"
          redirect_to root_path
        end
      else
        flash[:error] = "Sorry, we can't find a user with that email address. Try again?"
      end
    end
  end 	

  private

  def load_user_using_perishable_token
    @newsletter_subscriber = NewsletterSubscriber.find_by_perishable_token(params[:id])
    unless @newsletter_subscriber 
      flash[:notice] = "Oops. We're having trouble finding your account."
      redirect_to :action => "new"
    end
  end
end
