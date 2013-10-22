class AccoladesController < ApplicationController
  before_filter :require_user
  before_filter :get_accoladable, :only => [:new, :create,:edit]

  def new
    @accolade = @accoladable.accolades.build
    render :layout => false if request.xhr?
  end

  def create
    @accolade = @accoladable.accolades.build(params[:accolade])

    respond_to do |wants|
      if @accolade.save
        wants.html { redirect_to @accoladable.is_a?(Restaurant) ? edit_restaurant_path(@accoladable) : edit_user_profile_path(:user_id => @user.id) }
        wants.json do render :json => {
            :html => render_to_string(:partial => '/accolades/accolade.html.erb', :locals => {:accolade => @accolade}),
            :accolade => @accolade.to_json
        }
        end
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => "#{@accolade.accoladable.class.to_s.downcase}_form.html.erb"), :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @accolade = Accolade.find(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @accolade = Accolade.find(params[:id])
    unauthorized! unless can?(:edit, @accolade.accoladable)
    respond_to do |wants|
      if @accolade.update_attributes(params[:accolade])
        wants.html { 
          redirect_to @accolade.accoladable.is_a?(Restaurant) ? 
            edit_restaurant_path(@accolade.accoladable) : 
            edit_user_profile_path(:user_id => @accolade.accoladable.user.id)
        }
        wants.json { render :json => {
            :html => render_to_string(:partial => '/accolades/accolade.html.erb', :locals => {:accolade => @accolade}),
            :accolade => @accolade.to_json
        } }
      else
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => "#{@accolade.accoladable.class.downcase}_form.html.erb"), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @accolade = Accolade.find(params[:id])
    unauthorized! unless can?(:edit, @accolade.accoladable)
    if @accolade.destroy
      respond_to do |wants|
        wants.html { 
          redirect_to @accolade.accoladable.is_a?(Restaurant) ? 
            edit_restaurant_path(@accolade.accoladable) : 
            edit_user_profile_path(:user_id => @accolade.accoladable.user.id, :anchor => "profile-extended")
        }
        wants.js { render :nothing => true }
      end
    else
      respond_to do |wants|
        wants.html { render :new }
        wants.json { render :json => render_to_string(:partial => 'form.html.erb'), :status => :unprocessable_entity }
      end
    end
  end

  private

  def get_accoladable
    if params[:restaurant_id]
      @accoladable = @restaurant = Restaurant.find(params[:restaurant_id])
      redirect_to restaurant_path(@restaurant) unless can?(:edit, @accoladable)
    elsif params[:user_id]
      @user = User.find(params[:user_id])
      @accoladable = @user.profile
      redirect_to profile_path(@user.username) unless can?(:edit, @accoladable)
    end
  end
end