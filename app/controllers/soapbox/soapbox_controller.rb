class Soapbox::SoapboxController < ApplicationController


  def index
    get_home_page_data
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
    @restaurants = Restaurant.activated_restaurant.with_premium_account
    @use_search = true
    @no_sidebar = true
    render :template => "directory/restaurants"
  end

  def restaurant_search
    @restaurants = Restaurant.activated_restaurant.with_premium_account.search(params[:search]).all
    render :partial => "directory/restaurant_search_results"
  end

  def travel_guides
    redirect_to soapbox_btl_topic_path(Topic.travel)
  end

  private

  def get_home_page_data
    @questions = []
    restaurants_ids = Restaurant.activated_restaurant.with_premium_account.map{|e| e.id}    
    @menu_items = MenuItem.activated_restaurants.from_premium_restaurants.all(:order => "created_at DESC" ,:limit=>5)     
    #@questions = ALaMinuteQuestion.find(:all,:limit=>3,:conditions=>["id in (?) ",ALaMinuteAnswer.find(:all,:limit=>20,:select=>:a_la_minute_question_id).map {|row| row.a_la_minute_question_id}.uniq.compact[0..2]])
    @questions_ids = ALaMinuteAnswer.find(:all,:limit=>20,:select=>:a_la_minute_question_id).map {|row| row.a_la_minute_question_id}.uniq.compact[0..2]
    @questions_ids.each do |ids| @questions << ALaMinuteQuestion.find(ids)  end                  

    @behind_the_line_answers = ProfileQuestion.without_travel.answered_by_premium_and_public_users.all(:limit => 1).map(&:latest_soapbox_answer).uniq.compact[0...15]    
    @menus =  @menus =  Menu.find(:all,:conditions=>[" restaurant_id in (?)",restaurants_ids],:limit=>5,:group => :restaurant_id)
    @photos = Photo.find(:all,:conditions=>["attachable_type = ? and attachable_id  in (?)", 'Restaurant',restaurants_ids],:limit=>4)    
    @spotlight_user = User.in_soapbox_directory.last
    @rand_users = User.in_soapbox_directory.sample(2)
    @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC" ,:limit =>5)
    @answers = ProfileQuestion.without_travel.answered_by_premium_and_public_users.all(:limit => 5, :order => "profile_answers.created_at DESC").map(&:latest_soapbox_answer).uniq.compact[0...5]
    @restaurants = Restaurant.activated_restaurant.with_premium_account.sample(2)
    @main_feature = SoapboxEntry.main_feature    
    @main_feature_comments = SoapboxEntry.main_feature_comments(3) if @main_feature
    @qoth = SoapboxEntry.secondary_feature
    @qoth_comments = SoapboxEntry.secondary_feature_comments(3) if @qoth
    @blog_posts = WpBlogPost.find(:all, :conditions => ['post_status = "publish"'], :limit => 4,:order=>"post_date DESC")
  end
  
  
end
