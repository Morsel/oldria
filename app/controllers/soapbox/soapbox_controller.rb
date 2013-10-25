class Soapbox::SoapboxController < ApplicationController

include AutoCompleteHelper
  def index
    if params[:person] || params[:name]
      respond_to do |format|
        if params[:person]
          format.js { auto_complete_person_keywords }
        else
          format.js { auto_complete_keywords }
        end
      end
    else
      get_home_page_data
      @home = true
      @slides = SoapboxSlide.all(:order => "position", :limit => 5, :conditions => "position is not null")
      @promos = SoapboxPromo.all(:order => "position", :limit => 3, :conditions => "position is not null")
      render :layout => 'soapbox_home'
    end
  end

  def directory
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.search(:profile_specialties_id_equals => params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_soapbox_directory.search(:profile_cuisines_id_equals => params[:cuisine_id]).all(:order => "users.last_name").uniq
    else
      @use_search = true
      @users = User.in_soapbox_directory.all(:order => "users.last_name")
    end

    @no_sidebar = true
    render :template => "directory/index"
  end

  def directory_search
    if params[:search_person_by_state_or_region]
      params[:search_person_eq_any_name] = "_"
    else
      params[:search_person_by_state_or_region] = "_"
    end
    trace_search_for_persional_directory_for_soapbox
    if params[:search_person_eq_any_name] != "_"      
      @users = User.in_soapbox_directory.search(:profile_specialties_name_equals => params[:search_person_eq_any_name]).relation.uniq + User.in_soapbox_directory.search(:profile_cuisines_name_equals=>params[:search_person_eq_any_name]).relation.uniq
      @users = @users.push(User.in_soapbox_directory.find_by_name(params[:search_person_eq_any_name])).compact if @users.blank?
    else
      @users = User.in_soapbox_directory.search(:profile_metropolitan_area_name_or_profile_james_beard_region_name_equals=>params[:search_person_by_state_or_region]).relation.uniq
    end
    if @users.blank? && params[:search_person_by_state_or_region] != "_"
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
      @restaurants = Restaurant.search(:cuisine_id_equals =>params[:cuisine_id]).all.uniq
    elsif params[:metropolitan_area_id]
      @metro_area = MetropolitanArea.find(params[:metropolitan_area_id])
      @restaurants = Restaurant.search(:metropolitan_area_id_equals => params[:metropolitan_area_id]).all.uniq
    elsif params[:james_beard_region_id]
      @region = JamesBeardRegion.find(params[:james_beard_region_id])
      @restaurants = Restaurant.search(:james_beard_region_id_equals => params[:james_beard_region_id]).all.uniq
    else      
      @restaurants = Restaurant.all
    end
    @use_search = true
    @menu_item_keywords = MenuItemKeyword.all(:select=>"distinct otm_keyword_id",:limit=>9,:order=>"id desc")
    @recent_active_restaurants =  Restaurant.activated_restaurant.subscription_is_active.all(:limit=>9,:order=>"updated_at desc")
    @no_sidebar = true
    render :template => "directory/restaurants"
  end

  def restaurant_search
    if params[:search_restaurant_eq_any_name]
      params[:search_restaurant_by_state_or_region] = "_"
    else
      params[:search_restaurant_eq_any_name] = "_" 
    end
    trace_search_for_restaurant_directory_for_soapbox
    if params[:name] == "name"
      @restaurants = Restaurant.search(:name_begins_with => params[:search_restaurant_eq_any_name]).relation.uniq
    elsif params[:name] == "keyword"
      @restaurants = Restaurant.search(:menu_items_otm_keywords_name_begins_with => params[:search_restaurant_eq_any_name]).relation.uniq
    elsif params[:name] == "feature"
      @restaurants = Restaurant.search(:restaurant_features_value_begins_with => params[:search_restaurant_eq_any_name]).relation.uniq
    elsif params[:name] == "cuisine"
      @restaurants = Restaurant.search(:cuisine_name_begins_with => params[:search_restaurant_eq_any_name]).relation.uniq    
    elsif ( (params[:search_restaurant_eq_any_name]) && (params[:name].blank?) ) && (params[:search_restaurant_eq_any_name] != "_")
      @restaurants = Restaurant.search(:name_or_menu_items_otm_keywords_name_or_restaurant_features_value_or_cuisine_name_equals => params[:search_restaurant_eq_any_name]).relation.uniq
      @restaurants = Restaurant.search(:name_begins_with => params[:search_restaurant_eq_any_name]).relation if @restaurants.blank?
    elsif
      @restaurants = Restaurant.search(:state_or_james_beard_region_name_equals => params[:search_restaurant_by_state_or_region]).relation.uniq
    end
    if @restaurants.blank? && params[:search_restaurant_by_state_or_region] != "_"
      flash[:notice] = "I am sorry, we don't have any restaurants for your state yet. Sign up to receive notification when we do!"
    elsif @restaurants.blank?
      flash[:notice] = "No results found, please try a new search"
    end
    render :partial => "directory/restaurant_search_results"
  end

  def travel_guides
    redirect_to soapbox_btl_topic_path(Topic.travel)
  end

  def auto_complete_keywords
    @keywords = get_autocomplete_restaurant_result
    unless @keywords.present?      
      render :json => @keywords.push('No results found, please try a new search')
    else            
      render :json => @keywords
    end
  end
  
  def auto_complete_person_keywords
    @keywords = get_autocomplete_person_result
    unless @keywords.present?      
      render :json => @keywords.push('No results found, please try a new search')
    else      
      render :json => @keywords
    end
  end


  private

  def trace_search_for_restaurant_directory_for_soapbox
    if Restaurant.search(:menu_items_otm_keywords_name_equals => params[:search_restaurant_eq_any_name]).relation.present?
      @searchable_id =  OtmKeyword.find_by_name(params[:search_restaurant_eq_any_name]).id
      @searchable_type  = 'OtmKeyword' 
      @term = params["search_restaurant_eq_any_name"]
    elsif  Restaurant.search(:name_equals => params[:search_restaurant_eq_any_name]).relation.present?
      @searchable_id = Restaurant.find_by_name(params[:search_restaurant_eq_any_name]).id
      @searchable_type  = 'Restaurant' 
      @term = params["search_restaurant_eq_any_name"]   
    elsif Restaurant.search(:restaurant_features_value_equals => params[:search_restaurant_eq_any_name]).relation.present?
      @searchable_id = RestaurantFeature.find_by_value(params[:search_restaurant_eq_any_name]).id
      @searchable_type  = 'RestaurantFeature'
      @term = params["search_restaurant_eq_any_name"]  
    elsif Restaurant.search(:cuisine_name_equals => params[:search_restaurant_eq_any_name]).relation.present?  
      @searchable_id =  Cuisine.find_by_name(params[:search_restaurant_eq_any_name]).id
      @searchable_type  = 'Cuisine' 
      @term = params["search_restaurant_eq_any_name"]  
    elsif  Restaurant.search(:james_beard_region_name_equals => params[:search_restaurant_by_state_or_region]).relation.present?
      @searchable_id =  JamesBeardRegion.find_by_name(params[:search_restaurant_by_state_or_region]).id
      @searchable_type  = 'JamesBeardRegion' 
      @term = params["search_restaurant_by_state_or_region"]  
    elsif Restaurant.search(:state_equals=>params[:search_restaurant_by_state_or_region]).relation.present? 
      @searchable_type  = 'state' 
      @term = params["search_restaurant_by_state_or_region"]  
    else 
      @term = params["search_restaurant_by_state_or_region"] unless params["search_restaurant_by_state_or_region"].blank?
      @term = params["search_restaurant_eq_any_name"] unless params["search_restaurant_eq_any_name"].blank?  
    end 
      trace_search_for_soapbox
  end   

  def trace_search_for_persional_directory_for_soapbox
    if !params[:search_person_eq_any_name].blank? && User.in_soapbox_directory.find_by_name(params[:search_person_eq_any_name])
      @searchable_id =  User.find_by_name(params[:search_person_eq_any_name]).id
      @searchable_type  = 'User' 
      @term = params["search_person_eq_any_name"]
    elsif User.in_soapbox_directory.search(:profile_specialties_name_equals=> params[:search_person_eq_any_name]).relation.present?   
      @searchable_id =  Specialty.find_by_name(params[:search_person_eq_any_name]).id
      @searchable_type  = 'Specialty' 
      @term = params["search_person_eq_any_name"]
    elsif User.in_soapbox_directory.search(:profile_cuisines_name_equals => params[:search_person_eq_any_name]).relation.present?
      @searchable_id =  Cuisine.find_by_name(params[:search_person_eq_any_name]).id
      @searchable_type  = 'Cuisine' 
      @term = params["search_person_eq_any_name"]
    elsif User.in_soapbox_directory.search(:profile_metropolitan_area_name_equals => params[:search_person_by_state_or_region]).relation.present?
      @searchable_id = MetropolitanArea.find_by_name(params[:search_person_by_state_or_region]).id
      @searchable_type  = 'MetropolitanArea' 
      @term = params["search_person_by_state_or_region"]
    elsif  User.in_soapbox_directory.search(:profile_james_beard_region_name_equals => params[:search_person_by_state_or_region]).relation.present?
      @searchable_id = JamesBeardRegion.find_by_name(params[:search_person_by_state_or_region]).id
      @searchable_type  = 'JamesBeardRegion' 
      @term = params["search_person_by_state_or_region"]
    else 
      @term = params["search_person_eq_any_name"] unless params["search_person_eq_any_name"].blank?
      @term = params["search_person_by_state_or_region"] unless params["search_person_by_state_or_region"].blank?  
    end  
    trace_search_for_soapbox
  end   

  def trace_search_for_soapbox
    unless current_user.blank? 
      @trace_search =  SpoonfeedTraceSearche.find_by_searchable_id_and_searchable_type_and_user_id(@searchable_id,@searchable_type ,current_user.id)          
      @trace_search = @trace_search.nil? ? SpoonfeedTraceSearche.create(:searchable_id=>@searchable_id,:searchable_type=>@searchable_type,:user_id=>current_user.id,:term_name=>@term) : @trace_search.increment!(:count)  
    else
      @trace_search =  SpoonfeedTraceSearche.find_by_searchable_id_and_searchable_type_and_term_name(@searchable_id,@searchable_type,@term)   
      @trace_search = @trace_search.nil? ? SpoonfeedTraceSearche.create(:searchable_id=>@searchable_id,:searchable_type=>@searchable_type,:term_name=>@term) : @trace_search.increment!(:count)  
    end 
  end   

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
