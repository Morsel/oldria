class CompetitionsController < ApplicationController
  
  before_filter :require_user
  
  def new
    @profile = User.find(params[:user_id]).profile
    @competition = @profile.competitions.build
    render :layout => false if request.xhr?
  end

  def create
    @profile = User.find(params[:user_id]).profile
    @competition = @profile.competitions.build(params[:competition])

    respond_to do |wants|
      if @competition.save
        wants.html { redirect_to edit_user_profile_path(:user_id => @competition.profile.user.id) }
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
    @competition = Competition.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @competition = Competition.find(params[:id])

    respond_to do |wants|
      if @competition.update_attributes(params[:competition])
        wants.html { redirect_to edit_user_profile_path(:user_id => @competition.profile.user.id) }
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
    @competition = Competition.find(params[:id])
    if @competition.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @competition.profile.user.id) }
        wants.js { render :nothing => true }
      end
    end
  end

end
