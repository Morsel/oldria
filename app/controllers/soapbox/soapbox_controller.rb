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
    restaurants_ids = Restaurant.with_premium_account.map{|e| e.id}
    @menu_items = MenuItem.from_premium_restaurants.all(:order => "created_at DESC" ,:limit=>5)
    @questions = ALaMinuteQuestion.most_recent_for_soapbox(3)
    @behind_the_line_answers = (ProfileQuestion.without_travel.answered_by_premium_and_public_users.all(:limit => 50,:order => "profile_answers.created_at DESC").map(&:latest_soapbox_answer).uniq.compact[0...15]).compact[0..4]
    @menus =  @menus =  Menu.all(:limit=>5,:order=>"created_at desc")
    @photos = Photo.find(:all,:conditions=>["attachable_type = ? and attachable_id  in (?)", 'Restaurant',restaurants_ids],:limit=>4)    
    @spotlight_user = FeaturedProfile.spotlight_user.sample(1)  
    @spotlight_user =   @spotlight_user.blank? ? User.in_soapbox_directory.last : @spotlight_user.first.feature        
    @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC" ,:limit =>5)
    @featured_ptofiles = FeaturedProfile.personal_profiles.group_by(&:feature_type)
    @restaurants =  @featured_ptofiles["Restaurant"].blank? ?  Restaurant.premium_account.sample(2) : @featured_ptofiles["Restaurant"].sample(2).map{|row| row.feature}
    @rand_users = @featured_ptofiles["User"].blank? ?  User.in_soapbox_directory.sample(2) : @featured_ptofiles["User"].sample(2).map{|row| row.feature} 
    @main_feature = SoapboxEntry.main_feature    
    @main_feature_comments = SoapboxEntry.main_feature_comments(5) if @main_feature
    @qoth = SoapboxEntry.secondary_feature
    @qoth_comments = SoapboxEntry.secondary_feature_comments(5) if @qoth
    @blog_posts = WpBlogPost.find(:all, :conditions => ['post_status = "publish"'], :limit => 4,:order=>"post_date DESC")
  end
  
  
end
