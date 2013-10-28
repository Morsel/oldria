class MenuItemsController < ApplicationController

  before_filter :require_user

  before_filter :require_manager, :except => [:index,:get_keywords,:add_keywords,:details,:show]
  before_filter :social_redirect, :only => [:edit]
  before_filter :verify_restaurant_activation, :only => [:show]
  
  include MenuItemsHelper
  require 'will_paginate/array'
  
  def index
    find_restaurant
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    render :template => "menu_items/media_user/index" if cannot?(:edit, @restaurant)
  end

  def new
    @is_new = true
    @menu_item = MenuItem.new(:post_to_twitter_at => Time.now, :post_to_facebook_at => Time.now)
    @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
    build_social_posts
  end

  def create
    @menu_item = @restaurant.menu_items.build(params[:menu_item])
    if @menu_item.save
      flash[:notice] = "Your menu item has been saved"
      redirect_to :action => "index"
    else
      flash[:error] = @menu_item.errors.full_messages.to_sentence
      @is_new = true
      @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
      build_social_posts
      render :action => "new"
    end
  end

  def edit
    @menu_item = @restaurant.menu_items.find(params[:id])
    @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
    build_social_posts
  end

  def update
    @menu_item = @restaurant.menu_items.find(params[:id])
    if @menu_item.update_attributes(params[:menu_item])
      flash[:notice] = "Your menu item has been saved"
      redirect_to_social_or 'index'
    else
      @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
      build_social_posts
      render :action => "edit"
    end
  end

  def destroy
    @menu_item = @restaurant.menu_items.find(params[:id])
    if @menu_item.destroy
      flash[:notice] = "Your menu item has been deleted"
      redirect_to :action => "index"
    end
  end

  def facebook_post
    @menu_item = @restaurant.menu_items.find(params[:id])
    if @menu_item.post_to_facebook
      flash[:notice] = "Posted #{@menu_item.name} to Facebook page"
    else
      flash[:error] = "Not able to post #{@menu_item.name} to Facebook page"
    end  
    redirect_to :action => "index"
  end

  def get_keywords
    find_restaurant
    if params[:selected_keywords]
      @selected_keywords = params[:selected_keywords].split(",").map { |s| s.to_i }
    else
      @selected_keywords = []
    end
    @categories_keywords = OtmKeyword.find(:all,:conditions=>["name like ? ","%#{params[:search_keywords]}%"],:order => "category ASC, name ASC",:limit=>100) 
     respond_to do |wants|      
        wants.html { render :partial=>'get_keywords' }
    end
  end  

  def add_keywords   
    find_restaurant    
    UserMailer.add_keyword_request(@restaurant.name, params[:keywords]).deliver
    render :text=>"Request sent to admin,Wait for approval."  
  end

  def details
    @menu_item = MenuItem.find(:first,:conditions=>["menu_items.id= ?",params[:id]])     
    @restaurant = @menu_item.restaurant
    if current_user.media?
      UserRestaurantVisitor.profile_visitor(current_user,@restaurant.id)
    end 
  end

  def show
    
    @more_menu_items = MenuItem.all(:conditions => ["restaurant_id = ? AND id != ?", @menu_item.restaurant_id, @menu_item.id],
                                    :order => "created_at DESC",
                                    :limit => 5)
    @promotions = @menu_item.restaurant.promotions.all(:limit=>3,:order=>"created_at DESC",:conditions=>["DATE(promotions.start_date) >= DATE(?)", Time.now])
    @answers =  @menu_item.restaurant.a_la_minute_answers.all(:limit=>3,:order => "a_la_minute_answers.created_at DESC",:conditions=>["DATE(a_la_minute_answers.created_at) = DATE(?)", Time.now])
  end

  def verify_restaurant_activation        
      @menu_item = MenuItem.find(params[:id])       
      unless @menu_item.restaurant.is_activated?        
        flash[:error] = "This on the Menu page is unavailable."
        redirect_to :soapbox_menu_items   
      end
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def require_manager
    find_restaurant
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end

  def social_redirect
    if params[:social]
      session[:redirect_to_social_posts] = restaurant_social_posts_page_path(@restaurant, 'menu_items')
    end
  end

  def redirect_to_social_or(action)
    redirect_to (session[:redirect_to_social_posts].present?) ? session.delete(:redirect_to_social_posts) : { :action => action }
  end

  def build_social_posts
    (TwitterPost::POST_LIMIT - @menu_item.twitter_posts.size).times { @menu_item.twitter_posts.build }
    (FacebookPost::POST_LIMIT - @menu_item.facebook_posts.size).times { @menu_item.facebook_posts.build }
  end

end
