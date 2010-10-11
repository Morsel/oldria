class InternshipsController < ApplicationController
  
  before_filter :get_profile
  
  def new
    @internship = @profile.internships.build
    render :layout => false if request.xhr?
  end

  def create
    @internship = @profile.internships.build(params[:internship])

    respond_to do |wants|
      if @internship.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/internships/internship.html.erb', :locals => {:internship => @internship}),
            :internship => @internship.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @internship = @profile.internships.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @internship = @profile.internships.find(params[:id])

    respond_to do |wants|
      if @internship.update_attributes(params[:internship])
        wants.html { redirect_to edit_my_profile_path }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/internships/internship.html.erb', :locals => {:internship => @internship}),
          :internship => @internship.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @internship = @profile.internships.find(params[:id])
    if @internship.destroy
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
