class DirectoryController < ApplicationController
  include DirectoryHelper
  before_filter :require_user
#change search query according to meta_search instead of search_logic
  def index
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.search(:profile_specialties_id_equals => params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_spoonfeed_directory.search(:profile_cuisines_id_equals => params[:cuisine_id]).all(:order => "users.last_name").uniq
    elsif params[:metropolitan_area_id]
      @metro_area = MetropolitanArea.find(params[:metropolitan_area_id])
      @users = User.in_spoonfeed_directory.search(:profile_metropolitan_area_id_equals => params[:metropolitan_area_id]).all(:order => "users.last_name").uniq
    elsif params[:james_beard_region_id]
      @region = JamesBeardRegion.find(params[:james_beard_region_id])
      @users = User.in_spoonfeed_directory.search(:profile_james_beard_region_id_equals => params[:james_beard_region_id]).all(:order => "users.last_name").uniq
    else
      @use_search = true
      @users = User.in_spoonfeed_directory.all(:order => "users.last_name")
    end
  end

  def search
    directory_search_setup
    render :partial => "directory/search_results", :locals => { :users => @users }
  end
  
  def restaurants
    if params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @restaurants = Restaurant.activated_restaurant.search(:cuisine_id_eq => params[:cuisine_id]).all.uniq
    elsif params[:metropolitan_area_id]
      @metro_area = MetropolitanArea.find(params[:metropolitan_area_id])
      @restaurants = Restaurant.activated_restaurant.search(:metropolitan_area_id_equals => params[:metropolitan_area_id]).all.uniq
    elsif params[:james_beard_region_id]
      @region = JamesBeardRegion.find(params[:james_beard_region_id])
      @restaurants = Restaurant.activated_restaurant.search(:james_beard_region_id_equals => params[:james_beard_region_id]).all.uniq
    else
      @use_search = true
      @restaurants = Restaurant.activated_restaurant
      @menu_item_keywords = MenuItemKeyword.all(:select=>"distinct otm_keyword_id",:limit=>9,:order=>"updated_at desc")
      @recent_active_restaurants = Restaurant.activated_restaurant.all(:limit=>9,:order=>"updated_at desc") 
    end
  end
  
  def restaurant_search
    @restaurants = Restaurant.activated_restaurant.search(params[:search]).all(:order => "name").uniq
    render :partial => "restaurant_search_results"
  end

  def current_user_restaurants
    @restaurants = current_user.manager_restaurants
    render :layout => false
  end

  def get_restaurant_url
    @restaurant = Restaurant.find(params[:restaurant_id])
    @url = get_url_by_request params[:clicked_page]
    render :json =>{:url=>@url}
  end
  
  def search_restaurant_by_name
    #change search query according to meta_search instead of search_logic
    # add blank if not exist beacuse meta_search show all value if he get nil in search
    if params[:search_restaurant_eq_any_name]
      params[:search_restaurant_by_state_or_region] = "_"
    else
      params[:search_restaurant_eq_any_name] = "_" 
    end
    trace_search_for_restaurant_directory
    if params[:name] == "name"
      @restaurants = Restaurant.search(:starts_with => params[:search_restaurant_eq_any_name]).relation.uniq
    elsif params[:name] == "keyword"
      @restaurants = Restaurant.search(:menu_items_otm_keywords_name_starts_with => params[:search_restaurant_eq_any_name]).relation.uniq
    elsif params[:name] == "feature"
      @restaurants = Restaurant.search(:restaurant_features_value_starts_with => params[:search_restaurant_eq_any_name]).relation.uniq
    elsif params[:name] == "cuisine"
      @restaurants = Restaurant.search(:cuisine_name_starts_with => params[:search_restaurant_eq_any_name]).relation.uniq    
    elsif ( (params[:search_restaurant_eq_any_name]) && (params[:name].blank?) ) && (params[:search_restaurant_eq_any_name] != "_")
      @restaurants = Restaurant.search(:name_or_menu_items_otm_keywords_name_or_restaurant_features_value_or_cuisine_name_equals=>params[:search_restaurant_eq_any_name]).relation.uniq
      @restaurants = Restaurant.search(:name_starts_with => params[:search_restaurant_eq_any_name]) if @restaurants.blank?
    elsif
      @restaurants = Restaurant.search(:state_or_james_beard_region_name_equals => params[:search_restaurant_by_state_or_region]).relation.uniq
    end
    if @restaurants.blank? && params[:search_restaurant_by_state_or_region]!="_"
      flash[:notice] = "I am sorry, we don't have any restaurants for your state yet. Sign up to receive notification when we do!"
    end
    render :partial => "restaurant_search_results"
  end


  def search_user
    if params[:search_person_by_state_or_region]
      params[:search_person_eq_any_name] = "_"
    else
      params[:search_person_by_state_or_region] = "_"
    end
    if params[:soapbox]
      if params[:search_person_eq_any_name] != "_"
        @users = User.in_soapbox_directory.search(:profile_specialties_name_or_profile_cuisines_name_equals => params[:search_person_eq_any_name]).relation.uniq
        @users = @users.push(User.in_soapbox_directory.find_by_name(params[:search_person_eq_any_name])).compact if @users.blank?
      else
        @users = User.in_soapbox_directory.search(:profile_metropolitan_area_name_or_profile_james_beard_region_name_equals => params[:search_person_by_state_or_region]).relation.uniq
      end
    else
      trace_search_on_user_directory
      if params[:search_person_eq_any_name] !="_"
        @users = User.in_spoonfeed_directory.search(:profile_specialties_name_or_profile_cuisines_name_equals => params[:search_person_eq_any_name]).relation.uniq
        @users = @users.push(User.in_spoonfeed_directory.find_by_name(params[:search_person_eq_any_name])).compact if @users.blank?
      else
        @users = User.in_spoonfeed_directory.search(:profile_metropolitan_area_name_or_profile_james_beard_region_name_equals => params[:search_person_by_state_or_region]).relation.uniq
      end  
    end 
    if @users.blank? && params[:search_person_by_state_or_region] != "_"
      flash[:notice] = "I am sorry, we don't have any person for your state yet. Sign up to receive notification when we do!"
    end
    render :partial => "search_results"
  end  



  private 

   def trace_search_for_restaurant_directory
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
    elsif Restaurant.search(:state_equals => params[:search_restaurant_by_state_or_region]).relation.present? 
      @searchable_type  = 'state' 
      @term = params["search_restaurant_by_state_or_region"]
    else 
     @term = params["search_restaurant_by_state_or_region"] unless params["search_restaurant_by_state_or_region"].blank?
     @term = params["search_restaurant_eq_any_name"] unless params["search_restaurant_eq_any_name"].blank?
    end  
    trace_search
   end  


  
  def trace_search_on_user_directory
    if User.in_spoonfeed_directory.search(:profile_specialties_name_equals => params[:search_person_eq_any_name]).relation.present?
      @searchable_id =  Specialty.find_by_name(params[:search_person_eq_any_name]).id
      @searchable_type  = 'Specialty' 
      @term = params["search_person_eq_any_name"]
    elsif User.in_spoonfeed_directory.search(:profile_cuisines_name_equals => params[:search_person_eq_any_name]).relation.present?  
      @searchable_id =  Cuisine.find_by_name(params[:search_person_eq_any_name]).id
      @searchable_type  = 'Cuisine' 
      @term = params["search_person_eq_any_name"]
    elsif User.in_spoonfeed_directory.search(:profile_metropolitan_area_name_equals => params[:search_person_by_state_or_region]).relation.present? 
      @searchable_id =  MetropolitanArea.find_by_name(params[:search_person_by_state_or_region]).id
      @searchable_type  = 'MetropolitanArea'   
      @term = params["search_person_by_state_or_region"]
    elsif User.in_spoonfeed_directory.search(:profile_james_beard_region_name_equals => params[:search_person_by_state_or_region]).relation.present?
      @searchable_id =  JamesBeardRegion.find_by_name(params[:search_person_by_state_or_region]).id
      @searchable_type  = 'MetropolitanArea'  
      @term = params["search_person_by_state_or_region"]
    elsif  params[:search_person_eq_any_name].present? &&  User.in_spoonfeed_directory.find_by_name(params[:search_person_eq_any_name]).present?
      @searchable_id =  User.find_by_name(params[:search_person_eq_any_name]).id 
      @searchable_type  = 'User'  
      @term = params["search_person_eq_any_name"]
    else 
      @term = params["search_person_eq_any_name"] unless params["search_person_eq_any_name"].blank?
      @term = params["search_person_by_state_or_region"] unless params["search_person_by_state_or_region"].blank?
    end   
    trace_search
  end   

  def trace_search 
    @trace_search =  TraceSearch.find_by_searchable_id_and_searchable_type_and_user_id(@searchable_id,@searchable_type ,current_user.id)
    @trace_search = @trace_search.nil? ? TraceSearch.create(:searchable_id=>@searchable_id,:searchable_type=>@searchable_type,:user_id=>current_user.id,:term_name=>@term) : @trace_search.increment!(:count)  
  end

end