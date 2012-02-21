class DirectoryController < ApplicationController
  before_filter :require_user

  def index
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_spoonfeed_directory.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
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
      @restaurants = Restaurant.cuisine_id_eq(params[:cuisine_id]).all.uniq
    elsif params[:metropolitan_area_id]
      @metro_area = MetropolitanArea.find(params[:metropolitan_area_id])
      @restaurants = Restaurant.metropolitan_area_id_eq(params[:metropolitan_area_id]).all.uniq
    elsif params[:james_beard_region_id]
      @region = JamesBeardRegion.find(params[:james_beard_region_id])
      @restaurants = Restaurant.james_beard_region_id_eq(params[:james_beard_region_id]).all.uniq
    else
      @use_search = true
      @restaurants = Restaurant.all
    end
  end
  
  def restaurant_search
    @restaurants = Restaurant.search(params[:search]).all(:order => "name").uniq
    render :partial => "restaurant_search_results"
  end

end
