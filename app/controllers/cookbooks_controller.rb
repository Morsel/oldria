class CookbooksController < ApplicationController

  before_filter :require_user

  def new
    @profile = User.find(params[:user_id]).profile
    @cookbook = @profile.cookbooks.build
    render :layout => false if request.xhr?
  end

  def create
    @profile = User.find(params[:user_id]).profile
    @cookbook = @profile.cookbooks.build(params[:cookbook])
    respond_to do |wants|
      if @cookbook.save
        wants.html { redirect_to edit_user_profile_path(:user_id => @profile.user.id) }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/cookbooks/cookbook', :locals => {:cookbook => @cookbook}),
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
    @cookbook = Cookbook.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @cookbook = Cookbook.find(params[:id])
    respond_to do |wants|
      if @cookbook.update_attributes(params[:cookbook])
        wants.html { redirect_to edit_user_profile_path(:user_id => @cookbook.profile.user.id) }
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
    @cookbook = Cookbook.find(params[:id])
    if @cookbook.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_user_profile_path(:user_id => @cookbook.profile.user.id) }
        wants.js { render :nothing => true }
      end
    end
  end

end
