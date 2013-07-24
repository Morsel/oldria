class DirectoryController < ApplicationController
  include DirectoryHelper
  before_filter :require_user

  def index    
    if params[:specialty_id]
       @specialty = Specialty.find(params[:specialty_id])
       @users = User.in_soapbox_directory.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
       @keywordable_id = params[:specialty_id]
      @keywordable_type = 'Specialty'
     elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
       @users = User.in_spoonfeed_directory.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
       @keywordable_id = params[:cuisine_id]
       @keywordable_type = 'Cuisine'
     elsif params[:metropolitan_area_id]
      @metro_area = MetropolitanArea.find(params[:metropolitan_area_id])
       @users = User.in_spoonfeed_directory.profile_metropolitan_area_id_eq(params[:metropolitan_area_id]).all(:order => "users.last_name").uniq
     elsif params[:james_beard_region_id]
       @region = JamesBeardRegion.find(params[:james_beard_region_id])
       @users = User.in_spoonfeed_directory.profile_james_beard_region_id_eq(params[:james_beard_region_id]).all(:order => "users.last_name").uniq
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
      @restaurants = Restaurant.activated_restaurant.cuisine_id_eq(params[:cuisine_id]).all.uniq
    elsif params[:metropolitan_area_id]
      @metro_area = MetropolitanArea.find(params[:metropolitan_area_id])
      @restaurants = Restaurant.activated_restaurant.metropolitan_area_id_eq(params[:metropolitan_area_id]).all.uniq
    elsif params[:james_beard_region_id]
      @region = JamesBeardRegion.find(params[:james_beard_region_id])
      @restaurants = Restaurant.activated_restaurant.james_beard_region_id_eq(params[:james_beard_region_id]).all.uniq
    else      
      @use_search = true
      @restaurants = Restaurant.activated_restaurant
      @otm_keyword = OtmKeyword.all(:limit=>9)
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
    if params[:search_restaurant_eq_any_name]
      @restaurants = Restaurant.name_or_menu_items_otm_keywords_name_or_restaurant_features_value_or_cuisine_name_equals(params[:search_restaurant_eq_any_name]).uniq
      @restaurants = Restaurant.name_equals(params[:search_restaurant_eq_any_name]) if @restaurants.blank?
    elsif
      @restaurants = Restaurant.state_or_james_beard_region_name_equals(params[:search_restaurant_by_state_or_region]).uniq
    end
    if @restaurants.blank? && params[:search_restaurant_by_state_or_region].present?
      flash[:notice] = "I am sorry, we don't have any restaurants for your state yet. Sign up to receive notification when we do!"
    end
    render :partial => "restaurant_search_results"
  end


  def search_user
    if params[:soapbox]
      if params[:search_person_eq_any_name]
        @users = User.in_soapbox_directory.profile_specialties_name_or_profile_cuisines_name_equals(params[:search_person_eq_any_name]).uniq
        @users.push(User.in_soapbox_directory.find_by_name(params[:search_person_eq_any_name])) if @users.blank?
      else
        @users = User.in_soapbox_directory.profile_metropolitan_area_name_or_profile_james_beard_region_name_equals(params[:search_person_by_state_or_region]).uniq
      end
    else
      if params[:search_person_eq_any_name]
        @users = User.in_spoonfeed_directory.profile_specialties_name_or_profile_cuisines_name_equals(params[:search_person_eq_any_name]).uniq
        @users.push(User.in_spoonfeed_directory.find_by_name(params[:search_person_eq_any_name])) if @users.blank?
      else
        @users = User.in_spoonfeed_directory.profile_metropolitan_area_name_or_profile_james_beard_region_name_equals(params[:search_person_by_state_or_region]).uniq
      end  
    end 
    if @users.blank? && params[:search_person_by_state_or_region].present?
      flash[:notice] = "I am sorry, we don't have any person for your state yet. Sign up to receive notification when we do!"
    end
    render :partial => "search_results"
  end  

end


