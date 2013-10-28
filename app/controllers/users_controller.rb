class UsersController < ApplicationController

  before_filter :require_user, :only => [:show, :resume, :index,:edit_newsletters] 
  before_filter :require_owner_or_admin, :only => [:edit, :update, :remove_twitter, :remove_avatar,
                                                   :fb_auth, :fb_deauth, :fb_connect, :fb_page_auth,:upload]

  def index
    respond_to do |format|
      format.js { auto_complete_employees }
    end
  end

  def show
    get_user
    @keywordable_id = @user.id
    @keywordable_type = 'User'
  end

  def resume
    get_user
  end

  def edit
    redirect_to edit_user_profile_path(:user_id => @user.id)
  end

  def update     
    if params[:user]
      @employment_params = params[:user].delete(:default_employment)
      @editor_name = params[:user].delete(:editor)
    end

    respond_to do |format|
      if @editor_name.present?
        editor = User.find_by_name(@editor_name)
        if editor.present?
          @user.editors << editor
        else
          flash[:error] = "Sorry, we could not find the user you entered. Please try again."
          redirect_to edit_user_profile_path(:user_id => @user.id) and return
        end
      end

      if @user.update_attributes(params[:user])
        #TODU update the uservisitoremail setting next_email_at date
        UserRestaurantVisitor.new.check_email_frequency(@user.user_visitor_email_setting) if params[:user][:user_visitor_email_setting_attributes].present?
        # update default employment
        if @employment_params
          if @user.default_employment.present?
            @user.default_employment.update_attributes(@employment_params)
          else
            @user.create_default_employment(@employment_params)
          end
        end

        format.html do
          flash[:notice] = "Successfully updated your profile."
          redirect_to edit_user_profile_path(:user_id => @user.id) and return
        end
        format.js   { head :ok }       
      else
        @profile = @user.profile || @user.build_profile
        format.html { render :template => 'profiles/edit' }
        format.js   { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def confirm
    @user = User.find_by_perishable_token(params[:id])
    self.get_newsletter_data    
    if @user
      # render the page
    elsif current_user
      flash[:notice] = "Looks like you're already set up. Get to work!"
      redirect_to root_path
    else
      flash[:error] = "Oops, looks like that confirmation token has already been used.<br/>Log in below, or click the link to reset your password."
      redirect_to login_path
    end
  end

  def save_confirmation
    @user = User.find(params[:user_id])  
    # Force password reset
    @user.crypted_password = nil
    @user.newsfeed_promotion_types.destroy_all


    if @user.update_attributes(params[:user]) 
      update_newsletter_data(params[:user_id])

      @user.reset_perishable_token!
      @user.confirmed_at = Time.now
      @user_session = UserSession.new(@user)
      if @user_session.save
        flash[:notice] = "Welcome aboard! Your account has been confirmed."
        redirect_to root_path
      else
        flash[:error] = "Could not log you in. Please contact us for assistance."
      end
    else
      self.get_newsletter_data
      render :action => "confirm"
    end
  end

  def resend_confirmation
    require_no_user unless current_user && current_user.admin?
    if request.post?
      if user = User.find_by_email(params[:email])
        UserMailer.signup(user).deliver

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

  def remove_twitter
    @user.atoken  = nil
    @user.asecret = nil
    if @user.save
      flash[:message] = "Your Twitter account is no longer connected to your SpoonFeed account"
      redirect_to edit_user_profile_path(:user_id => @user.id)
    else
      render :edit
    end
  end

  def remove_avatar
    @user.avatar = nil
    if @user.save
      flash[:message] = "Got it! We've removed your headshot from your account"
      redirect_to edit_user_profile_path(:user_id => @user.id)
    else
      render :edit
    end
  end

  def fb_auth
  end

  def fb_deauth
    @user.update_attribute(:facebook_access_token, nil)
    @user.update_attribute(:facebook_page_token, nil)
    @user.update_attribute(:facebook_page_id, nil)
    flash[:notice] = "Your Facebook account has been disconnected"
    redirect_to params[:restaurant_id].present? ? edit_restaurant_path(params[:restaurant_id]) : edit_user_profile_path(:user_id => @user.id)
  end

  def fb_connect
    if current_facebook_user  
      unless params[:restaurant_id].blank? 
        @restaurant = Restaurant.find(params[:restaurant_id]) 
 
          @page = current_facebook_user.fetch        
          @restaurant.update_attributes!(:facebook_page_id => @page.id,
                                     :facebook_page_token => @page.client.access_token,
                                     :facebook_page_url => @page.link)
          extended_token = @restaurant.extend_access_token @restaurant.facebook_page_token
          @restaurant.update_attributes!(:facebook_page_token => extended_token["access_token"]) unless extended_token.blank?
      end
      # user_extended_token = @user.facebook_client(extended_token["access_token"])
      # @user.update_attribute(:facebook_page_token, user_extended_token.access_token)
      # @user.update_attribute(:facebook_page_id, current_facebook_user.id)       
      # @user.connect_to_facebook_user(current_facebook_user.id, user_extended_token.expiration)
      # if @user.facebook_access_token != current_facebook_user.client.access_token
      #   @user.update_attribute(:facebook_access_token, current_facebook_user.client.access_token)
      # end
      flash[:notice] = "Your Facebook account has been connected to your Spoonfeed account"
    else
      flash[:error] = "We were unable to connect your account. Please try again later."
    end
    redirect_to params[:restaurant_id].present? ? edit_restaurant_path(params[:restaurant_id]) : edit_user_profile_path(:user_id => @user.id)
  rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException ,Exception=> e
    Rails.logger.error("Unable to connect Facebook user account for #{@user.id} due to #{e.message} on #{Time.now}")
    flash[:error] = "We were unable to connect your account. Please log back into Facebook if you are logged out, or try again later."
    redirect_to params[:restaurant_id].present? ? edit_restaurant_path(params[:restaurant_id]) : edit_user_profile_path(:user_id => @user.id)
  end

  def fb_page_auth
    @page = current_facebook_user.accounts.select { |a| a.id == params[:facebook_page] }.first

    if @page
      @user.update_attributes!(:facebook_page_id => @page.id, :facebook_page_token => @page.access_token)
      flash[:notice] = "Added Facebook page #{@page.name} to your account"
    else
      @user.update_attributes!(:facebook_page_id => nil, :facebook_page_token => nil)
      flash[:notice] = "Cleared the Facebook page settings from your account"
    end

    redirect_to edit_user_profile_path(:user_id => @user.id)
  end

  def remove_editor
    get_user
    editor = User.find(params[:editor_id])
    @user.editors.delete(editor)
    flash[:notice] = "Removed #{editor.name} from editing your account"
    redirect_to edit_user_profile_path(:user_id => @user.id)
  end

  def upload
      if @user.update_attributes(params[:user])
        render :json=>{:status=>true}
      else
        render :json=>{:status=>false,:errors =>  @user.errors.as_json.uniq}
      end  

  end


  def edit_newsletters
    @user = User.find(params[:id]) 
    @subscriber = @user.newsletter_subscriber 
  end

  def add_region
    @james_beard_region = JamesBeardRegion.new 
    @user = User.find(params[:id])   
    render :layout => false if request.xhr?
  end 

  def new_james_beard_region
    @user = User.find(params[:user_id])
    @james_beard_region = JamesBeardRegion.new(params[:james_beard_region])
    respond_to do |wants|
      if @james_beard_region.valid? 
        UserMailer.send_james_bear_region_request(@james_beard_region,@user).deliver

        wants.json do render :json => {:html => "<li id='msg'><h3>Sent request to admin, will look into this.<h3></li>" }  end      
      else   
        wants.json { render :json => render_to_string(:file => "users/add_region.html.erb"), :status => :unprocessable_entity }
      end
    end
  end


  def user_profile_subscribe
    if current_user.media?     
      get_user
      ups = current_user.user_profile_subscribe(@user)   
      if ups.blank? && UserProfileSubscriber.create(:user_profile_subscriber => current_user, :user_id => @user.id)
        flash[:notice] = "#{current_user.email} is now subscribed to #{@user.name}'s profile."
      else  
        ups.destroy          
        flash[:notice] = "#{current_user.email} is unsubscribed to #{@user.name}'s profile."    
      end  
      redirect_to :action => "show", :username => @user.username
    end   
  end   

  private

  def get_user
    if params[:username]
      @user = User.find_by_username(params[:username])
      raise ActiveRecord::RecordNotFound, "Couldn't find User with username=#{params[:username]}" if @user.nil?
    else
      @user = User.find(params[:id])
    end
  end

  def owner?
    params[:id] && User.find(params[:id]) == current_user
  end

  def require_owner_or_admin
    get_user
    unauthorized! unless can?(:manage, @user)
  rescue CanCan::AccessDenied
    flash[:error] = "You are not authorized to access this page."
    redirect_to root_path
  end

  def auto_complete_employees
    @users = User.in_spoonfeed_directory.for_autocomplete.find_all_by_name(params[:term]) if params[:term]
    if @users
      render :json => @users.map(&:name)
    end
  end

end
