class ProfilesController < ApplicationController

  before_filter :require_user

  def edit
    @profile = current_user.profile || current_user.create_profile
    @fb_user = current_facebook_user.fetch if current_facebook_user && @profile.user.facebook_authorized?
  end

  def update
    @profile = current_user.profile || current_user.create_profile

    if params[:preview]
      @user = @profile.user
      @user.profile.attributes = params[:profile]
      render :template => "users/show" and return
    end

    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated profile."
      redirect_to profile_path(@profile.user.username)
    else
      render :edit
    end
  end
  
  def questions
    @profile = current_user.profile || current_user.create_profile
    @questions = @profile.user.profile_questions
  end
  
end
