class NonculinaryEnrollmentsController < ApplicationController

  before_filter :require_user

  def new
    @profile = User.find(params[:user_id]).profile
    @nonculinary_enrollment = @profile.nonculinary_enrollments.build
    render :layout => false if request.xhr?
  end

  def create
    @profile = User.find(params[:user_id]).profile
    @nonculinary_enrollment = @profile.nonculinary_enrollments.build(params[:nonculinary_enrollment])

    respond_to do |wants|
      if @nonculinary_enrollment.save
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id) }
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
    @nonculinary_enrollment = NonculinaryEnrollment.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @nonculinary_enrollment = NonculinaryEnrollment.find(params[:id])

    respond_to do |wants|
      if @nonculinary_enrollment.update_attributes(params[:nonculinary_enrollment])
        wants.html { redirect_to edit_user_profile_path(:user_id => @nonculinary_enrollment.profile.user.id) }
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
    @nonculinary_enrollment = NonculinaryEnrollment.find(params[:id])
    if @nonculinary_enrollment.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @nonculinary_enrollment.profile.user.id, :anchor => "profile-extended") }
        wants.js { render :nothing => true }
      end
    end
  end

end
