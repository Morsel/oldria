class CulinaryJobsController < ApplicationController
  before_filter :get_profile

  def new
    @culinary_job = @profile.culinary_jobs.build
    render :layout => false if request.xhr?
  end

  def create
    @culinary_job = @profile.culinary_jobs.build(params[:culinary_job])
    respond_to do |wants|
      if @culinary_job.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/culinary_jobs/culinary_job.html.erb', :locals => {:culinary_job => @culinary_job}),
            :culinary_job => @culinary_job.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @culinary_job = @profile.culinary_jobs.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @culinary_job = @profile.culinary_jobs.find(params[:id])
    respond_to do |wants|
      if @culinary_job.update_attributes(params[:culinary_job])
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/culinary_jobs/culinary_job.html.erb', :locals => {:culinary_job => @culinary_job}),
            :culinary_job => @culinary_job.to_json
          }
        end
      else
        wants.html { render :edit }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
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
