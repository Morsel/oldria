class ApprenticeshipsController < ApplicationController

  before_filter :get_profile
  
  def new
    @apprenticeship = @profile.apprenticeships.build
    render :layout => false if request.xhr?
  end

  def create
    @apprenticeship = @profile.apprenticeships.build(params[:apprenticeship])

    respond_to do |wants|
      if @apprenticeship.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/apprenticeships/apprenticeship.html.erb', :locals => {:apprenticeship => @apprenticeship}),
            :apprenticeship => @apprenticeship.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @apprenticeship = @profile.apprenticeships.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @apprenticeship = @profile.apprenticeships.find(params[:id])

    respond_to do |wants|
      if @apprenticeship.update_attributes(params[:apprenticeship])
        wants.html { redirect_to edit_my_profile_path }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/apprenticeships/apprenticeship.html.erb', :locals => {:apprenticeship => @apprenticeship}),
          :apprenticeship => @apprenticeship.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @apprenticeship = @profile.apprenticeships.find(params[:id])
    if @apprenticeship.destroy
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
