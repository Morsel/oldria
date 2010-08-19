class CulinaryJobsController < ApplicationController
  before_filter :get_profile

  def new
    @culinary_job = @profile.culinary_jobs.build
    render :layout => false if request.xhr?
  end

  def create
    @culinary_job = @profile.culinary_jobs.build(params[:culinary_job])
    if @culinary_job.save
      redirect_to edit_my_profile_path
    else
      render :new
    end
  end

  def edit
    @culinary_job = @profile.culinary_jobs.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @culinary_job = @profile.culinary_jobs.find(params[:id])
    if @culinary_job.update_attributes(params[:culinary_job])
      redirect_to edit_my_profile_path
    else
      render :edit
    end
  end

  def destroy
    @culinary_job = @profile.culinary_jobs.find(params[:id])
    if @culinary_job.destroy
      redirect_to edit_my_profile_path
    end
  end


  private

  def get_profile
    require_user
    @profile = (current_user.profile || current_user.create_profile)
  end
end
