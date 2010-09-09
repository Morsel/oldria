class AwardsController < ApplicationController
  before_filter :get_profile

  def new
    @award = @profile.awards.build
    render :layout => false if request.xhr?
  end

  def create
    @award = @profile.awards.build(params[:award])

    respond_to do |wants|
      if @award.save
        wants.html { redirect_to edit_my_profile_path }
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
    @award = @profile.awards.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @award = @profile.awards.find(params[:id])

    respond_to do |wants|
      if @award.update_attributes(params[:award])
        wants.html { redirect_to edit_my_profile_path }
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
    @award = @profile.awards.find(params[:id])
    if @award.destroy
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
