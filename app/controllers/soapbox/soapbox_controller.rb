class Soapbox::SoapboxController < ApplicationController

  def index
    @home = true

    @alm_links = ALaMinuteQuestion.all(:limit => 5, :order => "question")
    @btl_links = Topic.user_topics.all(:limit => 5, :order => "title")
  end

  def directory
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_soapbox_directory.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
    else
      directory_search_setup
      @use_search = true
    end

    @no_sidebar = true
    render :template => "directory/index"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results"
  end

  def restaurant_directory
    @restaurants = Restaurant.with_premium_account
    @no_sidebar = true
    render :template => "directory/restaurants"
  end

  def restaurant_search
    @restaurants = Restaurant.with_premium_account.search(params[:search]).all
    render :partial => "directory/restaurant_search_results"
  end

end
