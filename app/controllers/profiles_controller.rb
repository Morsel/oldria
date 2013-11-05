class ProfilesController < ApplicationController

  before_filter :require_user
  before_filter :find_user
  before_filter :find_or_build_profile, :only => [:edit, :edit_front_burner, :edit_account,:complete_profile]
  
  def create
    @profile = @user.build_profile(params[:profile])
    if @profile.save
      flash[:notice] = "Successfully created profile."
      redirect_to profile_path(@user.username)
    else
      @cusines = @profile.profile_cuisines.map(&:cuisine).map(&:name)
      @profile_cuisine = @profile.profile_cuisines.build
      flash[:error] = "Please fix the errors in the form below"
      render :edit
    end
  end

  def edit
    @cusines = @profile.profile_cuisines.map(&:cuisine).map(&:name)
    @profile_cuisine = @profile.profile_cuisines.build
    @fb_user = current_facebook_user.fetch if @profile.user.facebook_authorized? && current_facebook_user
    rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException,Exception => e
    Rails.logger.error("Unable to fetch Facebook user for restaurant editing due to #{e.message} on #{Time.now}")
  end

  def edit_btl
    render :layout => false
  end

  def edit_front_burner
    @qotds = @user.admin_conversations.current.recent
    resto_trends = @user.grouped_trend_questions.keys
    @trend_questions = (resto_trends.present? ? resto_trends : @user.solo_discussions.current.recent).sort_by(&:scheduled_at).reverse
    render :layout => false
  end

  def update
  @profile = @user.profile

   if params[:profile_cuisine] && params[:profile_cuisine][:cuisine_id]
     save_cusines
   end 
    respond_to do |wants|
      if @profile.update_attributes(params[:profile])
          flash[:notice] = "Successfully updated profile."
          wants.html { redirect_to edit_user_profile_path(:user_id => @user.id, :anchor => "profile-summary")}
          wants.json { render :json => {:status=>true}}
      else
        flash[:error] = "Please fix the errors in the form below"
        wants.html { render :edit }
        wants.json { render :json => {:status=>false}}
      end
    end
  end
  
  def toggle_publish_profile
    if current_user.update_attributes(:publish_profile => params[:publish_profile])
      render :partial => "shared/promotion_status"
    else
      render :partial => "shared/ajax_error" 
    end
  end

  def add_role_form
    render :partial => "profiles/add_role_form" 
  end  

  def complete_profile
  end

  def save_cusines
    params[:profile_cuisine][:cuisine_id].each do |profile_cuisine|
      params[:profile_cuisine][:cuisine_id] = profile_cuisine
      @profile_cuisine = @profile.profile_cuisines.build(params[:profile_cuisine])
    end   
  end 


  protected

  def find_user
    @user = User.find(params[:user_id])
    unauthorized! unless can?(:manage, @user)
  rescue CanCan::AccessDenied
    flash[:error] = "You are not authorized to access this page."
    redirect_to root_path
  end

  def find_or_build_profile
    #TODU for those user whoes profile is incomplete and account type is complimentry premium.validate in view
    @incomplete_profile =  @user.profile  
    @profile = @user.profile || @user.build_profile
  end

end
