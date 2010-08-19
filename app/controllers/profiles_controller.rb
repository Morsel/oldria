class ProfilesController < ApplicationController
  before_filter :require_user

  def edit
    @profile = current_user.profile || current_user.create_profile
    @profile.awards.build
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
      redirect_to edit_my_profile_path
    else
      render :edit
    end
  end
end
