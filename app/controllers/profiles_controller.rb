class ProfilesController < ApplicationController
  def edit
    @profile = current_user.profile || current_user.create_profile
    @profile.build_extended_items
  end

  def update
    @profile = current_user.profile || current_user.create_profile
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Successfully updated profile."
      redirect_to profile_path(current_user.try(:username))
    else
      render :edit
    end
  end
end
