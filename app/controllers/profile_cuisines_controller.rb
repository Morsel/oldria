class ProfileCuisinesController < ApplicationController

  before_filter :get_profile

  def new
    @profile_cuisine = @profile.profile_cuisines.build
    render :layout => false if request.xhr?
  end

  def create
    @profile_cuisine = @profile.profile_cuisines.build(params[:profile_cuisine])

    respond_to do |wants|
      if @profile_cuisine.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/profile_cuisines/profile_cuisine.html.erb', :locals => {:profile_cuisine => @profile_cuisine}),
            :award => @profile_cuisine.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  private

  def get_profile
    require_user
    @profile = (current_user.profile || current_user.create_profile)
  end

end
