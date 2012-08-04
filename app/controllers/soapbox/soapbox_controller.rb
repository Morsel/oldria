class Soapbox::SoapboxController < ApplicationController

  before_filter :get_home_page_data ,:only=>[:index]

  def index
    @home = true
    @slides = SoapboxSlide.all(:order => "position", :limit => 5, :conditions => "position is not null")
    @promos = SoapboxPromo.all(:order => "position", :limit => 3, :conditions => "position is not null")
    render :layout => 'soapbox_home'
  end

  def directory
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_soapbox_directory.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
    else
      @use_search = true
      @users = User.in_soapbox_directory.all(:order => "users.last_name")
    end

    @no_sidebar = true
    render :template => "directory/index"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results", :locals => { :users => @users }
  end

  def restaurant_directory
    @restaurants = Restaurant.with_premium_account
    @use_search = true
    @no_sidebar = true
    render :template => "directory/restaurants"
  end

  def restaurant_search
    @restaurants = Restaurant.with_premium_account.search(params[:search]).all
    render :partial => "directory/restaurant_search_results"
  end

  def travel_guides
    redirect_to soapbox_btl_topic_path(Topic.travel)
  end

  private

  def get_home_page_data
    
    restaurants_ids = Restaurant.activated_restaurant.with_premium_account.map{|e| e.id}
    @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC" ,:limit=>5)
    @questions = ALaMinuteQuestion.find(11,13,23) # for Today's menu specials are   
    @answers_13 = @questions.detect{|e| e[:id] ==13}.a_la_minute_answers.activated_restaurants.find(:all,:limit=>2 ,:order=>" created_at DESC")
    @answers_23 = @questions.detect{|e| e[:id] ==23}.a_la_minute_answers.activated_restaurants.find(:all,:limit=>2 ,:order=>" created_at DESC")
    @answers_11 = @questions.detect{|e| e[:id] ==11}.a_la_minute_answers.activated_restaurants.find(:all,:limit=>2 ,:order=>" created_at DESC")
    @behind_the_line_answers = ProfileQuestion.without_travel.answered_by_premium_and_public_users.all(:limit => 1).map(&:latest_soapbox_answer).uniq.compact[0...15]    
    @menus =  Menu.find(:all,:conditions=>[" restaurant_id in (?)",restaurants_ids],:limit=>5)    
    @photos = Photo.find(:all,:conditions=>["attachable_type = ? and attachable_id  in (?)", 'Restaurant',restaurants_ids],:limit=>4)
    #@profile =  Profile.last(:joins=>:user,:conditions=>"summary is not null and summary <> '' and users.publish_profile = true")    
    @spotlight_user = User.in_soapbox_directory.last
    @rand_users = User.in_soapbox_directory.sample(2)
    @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC" ,:limit =>5)
    @answers = ProfileQuestion.without_travel.answered_by_premium_and_public_users.all(:limit => 5, :order => "profile_answers.created_at DESC").map(&:latest_soapbox_answer).uniq.compact[0...5]
    @restaurants = Restaurant.activated_restaurant.with_premium_account.sample(2)
    @main_feature = SoapboxEntry.main_feature    
    @main_feature_comments = SoapboxEntry.main_feature_comments(3) if @main_feature
    @qoth = SoapboxEntry.secondary_feature
    @qoth_comments = SoapboxEntry.secondary_feature_comments(3) if @qoth
    @blog_posts = WpBlogPost.find(:all, :conditions => ['post_status = "publish"'], :limit => 4,:order=>"id DESC")
  end
  
  
end
