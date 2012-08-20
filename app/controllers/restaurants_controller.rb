class RestaurantsController < ApplicationController
  before_filter :require_user
  before_filter :authorize, :only => [:edit, :update, :select_primary_photo,
                                             :new_manager_needed, :replace_manager, :fb_page_auth,
                                             :remove_twitter, :download_subscribers, :activate_restaurant]
  before_filter :find_restaurant, :only => [:twitter_archive, :facebook_archive, :social_archive]

  def index
    @employments = current_user.employments
  end

  def new
    @restaurant = current_user.managed_restaurants.build
  end

  def create
    @restaurant = current_user.managed_restaurants.build(params[:restaurant])
    @restaurant.media_contact = current_user
    @restaurant.sort_name = params[:restaurant][:name]
    if @restaurant.save
      flash[:notice] = "Successfully created restaurant."
      redirect_to bulk_edit_restaurant_employees_path(@restaurant)
    else
      render :new
    end
  end

  def show
    find_activated_restaurant
    @employments = @restaurant.employments.by_position.all(
        :include => [:subject_matters, :restaurant_role, :employee])
    @questions = ALaMinuteAnswer.public_profile_for(@restaurant)[0...3]
    @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 5)
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
    @trend_answer = @restaurant.admin_discussions.for_trends.with_replies.first(:order => "created_at DESC")
  end

  def edit
    @fb_user = current_facebook_user.fetch if current_facebook_user && current_user.facebook_authorized?
  rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException => e
    Rails.logger.error("Unable to fetch Facebook user for restaurant editing due to #{e.message} on #{Time.now}")
  end

  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to @restaurant
    else
      flash[:error] = "We were unable to update the restaurant"
      render :edit
    end
  end

  def select_primary_photo
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Successfully updated restaurant"
      redirect_to bulk_edit_restaurant_photos_path(@restaurant)
    else
      flash[:error] = "We were unable to update the restaurant"
      render :template => "photos/edit"
    end
  end

  def new_manager_needed
  end

  def replace_manager
    old_manager = @restaurant.manager
    old_manager_employment = @restaurant.employments.find_by_employee_id(@restaurant.manager_id)
    new_manager = User.find(params[:manager])

    if @restaurant.update_attribute(:manager_id, new_manager.id) && old_manager_employment.destroy
      flash[:notice] = "Updated account manager to #{new_manager.name}. #{old_manager.name} is no longer an employee."
    else
      flash[:error] = "Something went wrong. Our worker bees will look into it."
    end

    redirect_to bulk_edit_restaurant_employees_path(@restaurant)
  end

  def fb_page_auth
    @page = current_facebook_user.accounts.select { |a| a.id == params[:facebook_page] }.first

    if @page
      @restaurant.update_attributes!(:facebook_page_id => @page.id,
                                     :facebook_page_token => @page.access_token,
                                     :facebook_page_url => @page.fetch.link)
      flash[:notice] = "Added Facebook page #{@page.name} to the restaurant"
    else
      @restaurant.update_attributes!(:facebook_page_id => nil, :facebook_page_token => nil)
      flash[:notice] = "Cleared the Facebook page settings from your restaurant"
    end

    redirect_to edit_restaurant_path(@restaurant)
  end

  def remove_twitter
    @restaurant.atoken  = nil
    @restaurant.asecret = nil
    if @restaurant.save
      flash[:message] = "Your Twitter account is no longer connected to your SpoonFeed restaurant account"
      redirect_to edit_restaurant_path(@restaurant)
    else
      render :edit
    end
  end

  def twitter_archive
  end

  def facebook_archive
  end

  def social_archive
  end

  def activate_restaurant
    if @restaurant.update_attributes(:is_activated => params[:mode])      
      flash[:notice] = params[:mode].to_i > 0  ? "Successfully activated restaurant" : "Successfully deactivated restaurant"
      redirect_to :restaurants
    else
      flash[:error] = "We were unable to update the restaurant"
      redirect_to :restaurants
    end
  end  

  def download_subscribers
    send_data(@restaurant.newsletter_subscribers.to_csv, :filename => "#{@restaurant.name} subscribers.csv")
  end

  private

  def find_activated_restaurant    
    find_restaurant
    unless can?(:manage, @restaurant) || @restaurant.is_activated?
      flash[:notice] = "This restaurant is not available to view."
      redirect_to root_path and return
    end
  end

  def find_restaurant    
    @restaurant = Restaurant.find(params[:id])
  end  

  def authorize
    find_restaurant
    if (cannot? :edit, @restaurant) || (cannot? :update, @restaurant)
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant and return
    end
  end

end
