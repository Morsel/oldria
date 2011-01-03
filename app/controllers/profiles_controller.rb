class ProfilesController < ApplicationController

  before_filter :require_user
  
  def create
    @profile = current_user.build_profile(params[:profile])

    if params[:preview]
      @user = @responder =current_user
      @user.profile.attributes = params[:profile]
      render :template => "users/show" and return
    end
    
    if @profile.save
      flash[:notice] = "Successfully created profile."
      redirect_to profile_path(@profile.user.username)
    else
      @user = current_user
      render :edit
    end
  end

  def edit
    @profile = current_user.profile || current_user.build_profile
    @user = current_user
    @fb_user = current_facebook_user.fetch if current_facebook_user && @profile.user.facebook_authorized?
  end

  def update
    @profile = current_user.profile

    if params[:preview]
      @user = @responder = current_user      
      @user.profile.attributes = params[:profile]
      render :template => "users/show" and return
    end

    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated profile."
      redirect_to profile_path(@profile.user.username)
    else
      @user = @profile.user
      render :edit
    end
  end
  
  def toggle_publish_profile
    if current_user.update_attributes(:prefers_publish_profile => params[:prefers_publish_profile])
      render :partial => "shared/promotion_status"
    else
      render :partial => "shared/ajax_error" 
    end
  end
end
