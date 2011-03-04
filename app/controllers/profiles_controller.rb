class ProfilesController < ApplicationController

  before_filter :require_user
  before_filter :find_user
  
  def create
    @profile = @user.build_profile(params[:profile])

    if @profile.save
      flash[:notice] = "Successfully created profile."
      redirect_to profile_path(@user.username)
    else
      flash[:error] = "Please fix the errors in the form below"
      render :edit
    end
  end

  def edit
    @profile = @user.profile || @user.build_profile
    @fb_user = current_facebook_user.fetch if current_facebook_user && @profile.user.facebook_authorized?
  end

  def update
    @profile = @user.profile

    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated profile."
      redirect_to edit_user_profile_path(:user_id => @user.id)
    else
      flash[:error] = "Please fix the errors in the form below"
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

  protected

  def find_user
    @user = User.find(params[:user_id])
    require_admin unless @user == current_user
  end
end
