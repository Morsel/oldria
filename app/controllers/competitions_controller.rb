class CompetitionsController < ApplicationController
  
  before_filter :get_profile
  
  def new
    @competition = @profile.competitions.build
    render :layout => false if request.xhr?
  end

  def create
    @competition = @profile.competitions.build(params[:competition])

    respond_to do |wants|
      if @competition.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/competitions/competition.html.erb', :locals => {:competition => @competition}),
            :competition => @competition.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @competition = @profile.competitions.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @competition = @profile.competitions.find(params[:id])

    respond_to do |wants|
      if @competition.update_attributes(params[:competition])
        wants.html { redirect_to edit_my_profile_path }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/competitions/competition.html.erb', :locals => {:competition => @competition}),
          :competition => @competition.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @competition = @profile.competitions.find(params[:id])
    if @competition.destroy
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
