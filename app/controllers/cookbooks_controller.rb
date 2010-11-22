class CookbooksController < ApplicationController
  before_filter :get_profile

  def new
    @cookbook = @profile.cookbooks.build
    render :layout => false if request.xhr?
  end

  def create
    @cookbook = @profile.cookbooks.build(params[:cookbook])
    respond_to do |wants|
      if @cookbook.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/cookbooks/cookbook.html.erb', :locals => {:cookbook => @cookbook}),
            :cookbook => @cookbook.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @cookbook = @profile.cookbooks.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @cookbook = @profile.cookbooks.find(params[:id])
    respond_to do |wants|
      if @cookbook.update_attributes(params[:cookbook])
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/cookbooks/cookbook.html.erb', :locals => {:cookbook => @cookbook}),
            :cookbook => @cookbook.to_json
          }
        end
      else
        wants.html { render :edit }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @cookbook = @profile.cookbooks.find(params[:id])
    if @cookbook.destroy
      redirect_to edit_my_profile_path
    end
  end


  private

  def get_profile
    require_user
    @profile = (current_user.profile || current_user.create_profile)
  end
end
