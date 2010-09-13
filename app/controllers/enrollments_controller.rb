class EnrollmentsController < ApplicationController
  before_filter :get_profile

  def new
    @enrollment = @profile.enrollments.build
    render :layout => false if request.xhr?
  end

  def create
    @enrollment = @profile.enrollments.build(params[:enrollment])

    respond_to do |wants|
      if @enrollment.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/enrollments/enrollment.html.erb', :locals => {:enrollment => @enrollment}),
            :enrollment => @enrollment.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @enrollment = @profile.enrollments.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @enrollment = @profile.enrollments.find(params[:id])

    respond_to do |wants|
      if @enrollment.update_attributes(params[:enrollment])
        wants.html { redirect_to edit_my_profile_path }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/enrollments/enrollment.html.erb', :locals => {:enrollment => @enrollment}),
          :enrollment => @enrollment.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @enrollment = @profile.enrollments.find(params[:id])
    if @enrollment.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_my_profile_path }
        wants.js { render :nothing => true }
      end

    end
  end


  private

  def get_profile
    require_user
    @profile = (current_user.profile || current_user.create_profile)
  end
end
