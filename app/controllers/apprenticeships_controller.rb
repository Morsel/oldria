class ApprenticeshipsController < ApplicationController

  before_filter :require_user
  
  def new
    @profile = User.find(params[:user_id]).profile
    @apprenticeship = @profile.apprenticeships.build
    render :layout => false if request.xhr?
  end

  def create
    @profile = User.find(params[:user_id]).profile
    @apprenticeship = @profile.apprenticeships.build(params[:apprenticeship])

    respond_to do |wants|
      if @apprenticeship.save
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id) }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/apprenticeships/apprenticeship.html.erb', 
                                      :locals => {:apprenticeship => @apprenticeship}),
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
    @apprenticeship = Apprenticeship.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @apprenticeship = Apprenticeship.find(params[:id])

    respond_to do |wants|
      if @apprenticeship.update_attributes(params[:apprenticeship])
        wants.html { redirect_to edit_user_profile_path(:user_id => @apprenticeship.profile.user.id) }
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
    @apprenticeship = Apprenticeship.find(params[:id])
    if @apprenticeship.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @apprenticeship.profile.user.id) }
        wants.js { render :nothing => true }
      end
    end
  end

end
