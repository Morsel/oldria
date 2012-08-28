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
    @photos = Photo.find(:all,:conditions=>["attachable_type = ? and attachable_id  in (?)", 'Restaurant',restaurants_ids],:limit=>4,:order=>"created_at desc")    
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
    @blog_posts =  WpBlogPost.find_by_sql("select wp_postmeta.*,wp_posts.post_date as post_date from wp_postmeta join wp_posts on wp_posts.id = wp_postmeta.post_id where post_id in (SELECT wmpm.post_id FROM `wp_posts` wp join wp_mf_post_meta wmpm on wmpm.post_id = wp.id  join wp_postmeta wpm on wpm.meta_id = wmpm.meta_id group by post_id having count(wmpm.post_id) >1) and (meta_key = 'soapbox_home_page_description' or meta_key = 'soapbox_home_page_title') and wp_posts.post_status = 'publish' order by wp_posts.post_date DESC limit 8")
    @my_hash = Hash.new
    @blog_posts.each {|row|  @my_hash[row.post_id] = Hash.new }
    @blog_posts.each {|row|  @my_hash[row.post_id][row.meta_key] = row}    
    @box1 = @my_hash[@my_hash.keys[2]] 
    @box2 = @my_hash[@my_hash.keys[0]]
    @box3 = @my_hash[@my_hash.keys[1]]
    @box4 = @my_hash[@my_hash.keys[3]]
  end
  
  
end
