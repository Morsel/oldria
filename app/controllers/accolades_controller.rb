class AccoladesController < ApplicationController
  before_filter :get_accoladable

  def new
    @accolade = @accoladable.accolades.build
    render :layout => false if request.xhr?
  end

  def create
    @accolade = @accoladable.accolades.build(params[:accolade])

    respond_to do |wants|
      if @accolade.save
        wants.html { redirect_to edit_my_profile_path }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/accolades/accolade.html.erb', :locals => {:accolade => @accolade}),
            :accolade => @accolade.to_json
          }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @accolade = @accoladable.accolades.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @accolade = @accoladable.accolades.find(params[:id])

    respond_to do |wants|
      if @accolade.update_attributes(params[:accolade])
        wants.html { redirect_to edit_my_profile_path }
        wants.json { render :json => {
          :html => render_to_string(:partial => '/accolades/accolade.html.erb', :locals => {:accolade => @accolade}),
          :accolade => @accolade.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @accolade = @accoladable.accolades.find(params[:id])
    if @accolade.destroy
      respond_to do |wants|
        wants.html { redirect_to edit_my_profile_path }
        wants.js { render :nothing => true }
      end

    end
  end


  private

  def get_accoladable
    if params[:restaurant_id]
      @accoladable = Restaurant.find(params[:restaurant_id])
    else
      require_user
      @accoladable = (current_user.profile || current_user.create_profile)
    end
  end
end
