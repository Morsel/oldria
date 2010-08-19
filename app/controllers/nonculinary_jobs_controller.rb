class NonculinaryJobsController < ApplicationController
  before_filter :get_profile

  def new
    @nonculinary_job = @profile.nonculinary_jobs.build
    render :layout => false if request.xhr?
  end

  def create
    @nonculinary_job = @profile.nonculinary_jobs.build(params[:nonculinary_job])
    respond_to do |wants|
      if @nonculinary_job.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/nonculinary_jobs/nonculinary_job.html.erb', :locals => {:nonculinary_job => @nonculinary_job}),
            :nonculinary_job => @nonculinary_job.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @nonculinary_job = @profile.nonculinary_jobs.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @nonculinary_job = @profile.nonculinary_jobs.find(params[:id])
    respond_to do |wants|
      if @nonculinary_job.update_attributes(params[:nonculinary_job])
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/nonculinary_jobs/nonculinary_job.html.erb', :locals => {:nonculinary_job => @nonculinary_job}),
            :nonculinary_job => @nonculinary_job.to_json
          }
        end
      else
        wants.html { render :edit }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
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
