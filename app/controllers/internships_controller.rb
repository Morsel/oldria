class InternshipsController < ApplicationController
  
  before_filter :require_user
  
  def new
    @profile = User.find(params[:user_id]).profile
    @internship = @profile.internships.build
    render :layout => false if request.xhr?
  end

  def create
    @profile = User.find(params[:user_id]).profile
    @internship = @profile.internships.build(params[:internship])

    respond_to do |wants|
      if @internship.save
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id) }
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
    @internship = Internship.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @internship = Internship.find(params[:id])

    respond_to do |wants|
      if @internship.update_attributes(params[:internship])
        wants.html { redirect_to edit_user_profile_path(:user_id => @internship.profile.user.id) }
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
    @internship = Internship.find(params[:id])
    if @internship.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @internship.profile.user.id, :anchor => "profile-extended") }
        wants.js { render :nothing => true }
      end
    end
  end

end
