class AwardsController < ApplicationController

  before_filter :require_user

  def new
    @profile = User.find(params[:user_id]).profile
    @award = @profile.awards.build
    render :layout => false if request.xhr?
  end

  def create
    @profile = User.find(params[:user_id]).profile
    @award = @profile.awards.build(params[:award])

    respond_to do |wants|
      if @award.save
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id) }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/awards/award.html.erb', :locals => {:award => @award}),
            :award => @award.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @award = Award.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @award = Award.find(params[:id])

    respond_to do |wants|
      if @award.update_attributes(params[:award])
        wants.html { redirect_to edit_user_profile_path(:user_id => @award.profile.user.id) }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/awards/award.html.erb', :locals => {:award => @award}),
          :award => @award.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @award = Award.find(params[:id])
    if @award.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @award.profile.user.id) }
        wants.js { render :nothing => true }
      end
    end
  end

end
