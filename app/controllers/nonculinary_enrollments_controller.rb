class NonculinaryEnrollmentsController < ApplicationController
  before_filter :get_profile

  def new
    @nonculinary_enrollment = @profile.nonculinary_enrollments.build
    render :layout => false if request.xhr?
  end

  def create
    @nonculinary_enrollment = @profile.nonculinary_enrollments.build(params[:nonculinary_enrollment])

    respond_to do |wants|
      if @nonculinary_enrollment.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/nonculinary_enrollments/nonculinary_enrollment.html.erb', :locals => {:nonculinary_enrollment => @nonculinary_enrollment}),
            :nonculinary_enrollment => @nonculinary_enrollment.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @nonculinary_enrollment = @profile.nonculinary_enrollments.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @nonculinary_enrollment = @profile.nonculinary_enrollments.find(params[:id])

    respond_to do |wants|
      if @nonculinary_enrollment.update_attributes(params[:nonculinary_enrollment])
        wants.html { redirect_to edit_my_profile_path }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/nonculinary_enrollments/nonculinary_enrollment.html.erb', :locals => {:nonculinary_enrollment => @nonculinary_enrollment}),
          :nonculinary_enrollment => @nonculinary_enrollment.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @nonculinary_enrollment = @profile.nonculinary_enrollments.find(params[:id])
    if @nonculinary_enrollment.destroy
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
