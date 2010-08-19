class NonculinaryJobsController < ApplicationController
  before_filter :get_profile

  def new
    @nonculinary_job = @profile.nonculinary_jobs.build
  end

  def create
    @nonculinary_job = @profile.nonculinary_jobs.build(params[:nonculinary_job])
    if @nonculinary_job.save
      redirect_to edit_my_profile_path
    else
      render :new
    end
  end

  def edit
    @nonculinary_job = @profile.nonculinary_jobs.find(params[:id])
  end

  def update
    @nonculinary_job = @profile.nonculinary_jobs.find(params[:id])
    if @nonculinary_job.update_attributes(params[:nonculinary_job])
      redirect_to edit_my_profile_path
    else
      render :edit
    end
  end

  def destroy
    @nonculinary_job = @profile.nonculinary_jobs.find(params[:id])
    if @nonculinary_job.destroy
      redirect_to edit_my_profile_path
    end
  end


  private

  def get_profile
    require_user
    @profile = (current_user.profile || current_user.create_profile)
  end
end
