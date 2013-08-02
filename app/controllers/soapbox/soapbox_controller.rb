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
    if params[:search_person_eq_any_name]
      @users = User.in_soapbox_directory.profile_specialties_name_or_profile_cuisines_name_equals(params[:search_person_eq_any_name]).uniq
      @users = @users.push(User.in_soapbox_directory.find_by_name(params[:search_person_eq_any_name])).compact if @users.blank?
    else
      @users = User.in_soapbox_directory.profile_metropolitan_area_name_or_profile_james_beard_region_name_equals(params[:search_person_by_state_or_region]).uniq
    end
    if @users.blank? && params[:search_person_by_state_or_region].present?
      flash[:notice] = "I am sorry, we don't have any person for your state yet. Sign up to receive notification when we do!"
    elsif @users.blank?
      flash[:notice] = "No results found, please try a new search"
    end
    render :partial => "directory/search_results"
  end

  def restaurant_directory
    @subscriber = current_subscriber
    if params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @restaurants = Restaurant.cuisine_id_eq(params[:cuisine_id]).all.uniq
    elsif params[:metropolitan_area_id]
      @metro_area = MetropolitanArea.find(params[:metropolitan_area_id])
      @restaurants = Restaurant.metropolitan_area_id_eq(params[:metropolitan_area_id]).all.uniq
    elsif params[:james_beard_region_id]
      @region = JamesBeardRegion.find(params[:james_beard_region_id])
      @restaurants = Restaurant.james_beard_region_id_eq(params[:james_beard_region_id]).all.uniq
    else      
      @restaurants = Restaurant.all
    end
    @use_search = true
    @otm_keyword = OtmKeyword.all(:limit=>9)
    @no_sidebar = true
    render :template => "directory/restaurants"
  end

  def restaurant_search
    if params[:search_restaurant_eq_any_name]
      @restaurants = Restaurant.name_or_menu_items_otm_keywords_name_or_restaurant_features_value_or_cuisine_name_equals(params[:search_restaurant_eq_any_name]).uniq
      @restaurants = Restaurant.name_equals(params[:search_restaurant_eq_any_name]) if @restaurants.blank?
    elsif
      @restaurants = Restaurant.state_or_james_beard_region_name_equals(params[:search_restaurant_by_state_or_region]).uniq
    end
    if @restaurants.blank? && params[:search_restaurant_by_state_or_region].present?
      flash[:notice] = "I am sorry, we don't have any restaurants for your state yet. Sign up to receive notification when we do!"
    elsif @restaurants.blank?
      flash[:notice] = "No results found, please try a new search"
    end
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
    @menus =  Menu.all(:limit=>5,:order=>"menus.created_at desc",:include => :restaurant,:conditions=>["restaurants.is_activated=true and restaurants.id in (?)",restaurants_ids])
    @photos = Photo.find(:all,:conditions=>["attachable_type = ? and attachable_id  in (?)", 'Restaurant',restaurants_ids],:limit=>4,:order=>"created_at desc")    
    @spotlight_user = FeaturedProfile.spotlight_user.sample(1)  
    @spotlight_user =   @spotlight_user.blank? ? User.in_soapbox_directory.last : @spotlight_user.first.feature        
    @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC" ,:limit =>5)
    @featured_ptofiles = FeaturedProfile.personal_profiles.group_by(&:feature_type)    
    feature_restaurants =[]
    feature_restaurants = @featured_ptofiles["Restaurant"].map{|row| row.feature if row.feature.linkable_profile?} unless  @featured_ptofiles["Restaurant"].blank?
    @restaurants = feature_restaurants.blank? ?  Restaurant.with_premium_account.sample(2) : feature_restaurants.sample(2)
    @restaurants = Restaurant.with_premium_account.sample(2) if @restaurants.blank?
    @rand_users = @featured_ptofiles["User"].blank? ?  User.in_soapbox_directory.sample(2) : @featured_ptofiles["User"].sample(2).map{|row| row.feature} 
    @main_feature = SoapboxEntry.main_feature    
    @main_feature_comments = SoapboxEntry.main_feature_comments(5) if @main_feature
    @qoth = SoapboxEntry.secondary_feature
    @qoth_comments = SoapboxEntry.secondary_feature_comments(5) if @qoth    

  end
  
  
end
