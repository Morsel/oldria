class CompleteRegistrationsController < ApplicationController
  
  before_filter :require_user

  ##
  # GET /complete_registration
  def show
    @user = current_user
  end

  ##
  # PUT /complete_registration
  def update
    @user = User.find(params[:user].delete(:id))
    force_password_reset unless params[:step] == '2'
    if @user.update_attributes(params[:user])
      @user.reset_perishable_token! unless params[:step] == '2'
      if @user.primary_employment.present?
        
        # if restaurant name matches an existing one, go to the find_restaurant workflow
        if @user.primary_employment.solo_restaurant_name.present? && 
            Restaurant.exists?(["name like ?", "%#{@user.primary_employment.solo_restaurant_name}%"])
          redirect_to :action => "find_restaurant", :restaurant_name => @user.primary_employment.solo_restaurant_name
        else
          flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
          redirect_to(root_path)
        end
        
      else
        redirect_to(:action => "user_details")
      end
    else
      params[:step] == '2' ? render(:action => 'user_details') : render(:show)
    end
  end

  # A form view to setup profile and default employment
  def user_details
    @user = current_user
    invitation = @user.invitation
    if invitation.present?
      solo_restaurant_name = invitation.restaurant_id ? 
        Restaurant.find(invitation.restaurant_id).name :
        invitation.restaurant_name
      @user.build_default_employment(:solo_restaurant_name => solo_restaurant_name, 
        :restaurant_role => invitation.restaurant_role, :subject_matters => invitation.subject_matters)
    else
      @user.build_default_employment
    end
    @user.build_profile
  end

  def add_employment
    @user = current_user   
  end

  def create_employment  
    @user = current_user   
    
    if @user.default_employment.present?
      @user.default_employment.update_attributes(params[:user][:default_employment])
    else
      @user.build_default_employment(params[:user][:default_employment]).save
    end
    
    if @user.default_employment.valid?
      flash[:notice] = "Successfully updated your profile."
      respond_to do |wants|
        wants.html do          
          redirect_to edit_user_profile_path(:user_id => @user.id)  
        end
        wants.json { render :json =>{:status=>true,:url=>edit_user_profile_path(:user_id => @user.id)}  }
      end
    else
      respond_to do |wants|
        wants.html { render :add_employment }
        wants.json { render :json => render_to_string(:partial => "profiles/add_role_form.html.erb"), :status => :unprocessable_entity }
      end
    end  
  end

  def find_restaurant
    if params[:restaurant_name]
      @restaurants = Restaurant.find(:all, :conditions => ["name like ?", "%#{params[:restaurant_name]}%"])
    end
     respond_to do |wants|
        wants.html 
        wants.json { render :json =>  @restaurants.collect{|e| {:value=>e.name,:label=>e.name} }.to_json }
     end 

  end
  
  def contact_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    if @restaurant
      UserMailer.deliver_employee_request(@restaurant, current_user)
      flash[:notice] = "We've contacted the restaurant manager. Thanks for setting up your account, and enjoy SpoonFeed!"
      redirect_to root_path
    end
  end
  
  def finish_without_contact
    flash[:notice] = "Thanks for updating your account. Enjoy SpoonFeed!"
    redirect_to root_path
  end

  private
  
  def force_password_reset
    return unless params[:user]
    @user.crypted_password = nil
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end
  
end
