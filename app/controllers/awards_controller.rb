class AwardsController < ApplicationController
  before_filter :get_profile

  def new
    @award = @profile.awards.build
    render :layout => false if request.xhr?
  end

  def create
    @award = @profile.awards.build(params[:award])
    if @award.save
      redirect_to edit_my_profile_path
    else
      render :new
    end
  end

  def edit
    @award = @profile.awards.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @award = @profile.awards.find(params[:id])
    if @award.update_attributes(params[:award])
      redirect_to edit_my_profile_path
    else
      render :edit
    end
  end

  def destroy
    @award = @profile.awards.find(params[:id])
    if @award.destroy
      redirect_to edit_my_profile_path
    end
  end


  private

  def get_profile
    require_user
    @profile = (current_user.profile || current_user.create_profile)
  end
end
