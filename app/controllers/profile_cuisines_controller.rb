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
        @user = @profile.user
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id, :anchor => "profile-summary") }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/profile_cuisines/profile_cuisine.html.erb', :locals => {:profile_cuisine => @profile_cuisine,:cuisine=>@profile_cuisine.cuisine
}),
            :profile_cuisine => @profile_cuisine.to_json,:status=>true
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile_cuisine = ProfileCuisine.find(params[:id])
    if @profile_cuisine.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id, :anchor => "profile-summary") }
        wants.js { render :nothing => true }
      end
    end
  end

  private

  def get_profile
    require_user
    @profile = User.find(params[:user_id]).profile
    unauthorized! if cannot? :edit, @profile
  end

end
