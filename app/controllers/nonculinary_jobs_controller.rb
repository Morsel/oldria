class NonculinaryJobsController < ApplicationController
  before_filter :require_user

  def new
    @profile = User.find(params[:user_id]).profile
    @nonculinary_job = @profile.nonculinary_jobs.build
    render :layout => false if request.xhr?
  end

  def create
    @profile = User.find(params[:user_id]).profile
    @nonculinary_job = @profile.nonculinary_jobs.build(params[:nonculinary_job])
    respond_to do |wants|
      if @nonculinary_job.save
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id) }
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
    @nonculinary_job = NonculinaryJob.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @nonculinary_job = NonculinaryJob.find(params[:id])
    respond_to do |wants|
      if @nonculinary_job.update_attributes(params[:nonculinary_job])
        wants.html { redirect_to edit_user_profile_path(:user_id => @nonculinary_job.profile.user.id) }
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
    @nonculinary_job = NonculinaryJob.find(params[:id])
    if @nonculinary_job.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @nonculinary_job.profile.user.id, :anchor => "profile-extended") }
        wants.js { render :nothing => true }
      end
    end
  end

end
