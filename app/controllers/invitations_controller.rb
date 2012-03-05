class InvitationsController < ApplicationController

  before_filter :logout_current_user, :only => [:new, :show]
  before_filter :require_no_user, :only => [:create]
  before_filter :find_user_from_params, :only => [:show]
  before_filter :require_user, :only => [:recommend, :submit_recommendation]
  
  def new
    @invitation = Invitation.new(params[:invitation])
  end
  
  def create
    @invitation = Invitation.new(params[:invitation])
    if @invitation.save
      redirect_to :action => "confirm", :id => @invitation.id
    else
      render :new
    end
  end

  def confirm
    @invitation = Invitation.find(params[:id])
  end

  # This is where "accept Spoonfeed invite" links go. They have both a perishable token and a user id.
  # If the perishable token is still good, we send the user to complete their registration.
  # If it has been reset, we assume they have set a new password and should go log in.
  def show
    if @user
      @user.confirm! unless @user.confirmed? # we know their email address works because that's how they got here
      UserSession.create(@user) # log them in

      flash[:notice] = "Successfully logged in. Please take a moment and update your account information."
      redirect_to complete_registration_path
    elsif params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])

      if @user.confirmed && current_user
        flash[:notice] = "Cool! It looks like you're already set up for SpoonFeed."
        redirect_to root_path
      elsif @user.confirmed
        flash[:notice] = "Cool! It looks like you're already set up for SpoonFeed.<br/>Log in below to start having fun!"
        redirect_to login_path(:user_session => {:username => @user.username})
      else
        flash[:error] = "Something went wrong trying to confirm your account. Please request a new confirmation email below."
        redirect_to resend_confirmation_users_path
      end
    else
      flash[:error] = "We could not locate your account."
      redirect_to login_path, :user_id => params[:user_id]
    end
  end

  # FIXME - this will be deprecated at end of redesign-2011 and should be removed
  def redirect
    if params[:role] == "restaurant"
      redirect_to :action => "new", :invitation => { :first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email] }
    elsif params[:role] == "media"
      redirect_to :controller => "mediafeed/media_users", :action => "new", :user => { :first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email] }
    end
  end

  def recommend
  end
  
  def submit_recommendation
    for email in params[:emails].split(/\n/)
      UserMailer.deliver_signup_recommendation(email, current_user)
    end
    
    flash[:notice] = "Thanks for recommending new members!"
    redirect_to :action => "recommend"
  end

  private
  
  def logout_current_user
    session = UserSession.find
    session.destroy if session
    @current_user = nil
  end

  def find_user_from_params
    @user = User.find_using_perishable_token(params[:id])
  end
end
