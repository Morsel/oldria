class StagesController < ApplicationController
  
  before_filter :get_profile
  
  def new
    @stage = @profile.stages.build
    render :layout => false if request.xhr?
  end

  def create
    @stage = @profile.stages.build(params[:stage])

    respond_to do |wants|
      if @stage.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/stages/stage.html.erb', :locals => {:stage => @stage}),
            :stage => @stage.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @stage = @profile.stages.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @stage = @profile.stages.find(params[:id])

    respond_to do |wants|
      if @stage.update_attributes(params[:stage])
        wants.html { redirect_to edit_my_profile_path }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/stages/stage.html.erb', :locals => {:stage => @stage}),
          :stage => @stage.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @stage = @profile.stages.find(params[:id])
    if @stage.destroy
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
