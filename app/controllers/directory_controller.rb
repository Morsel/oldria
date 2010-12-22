class DirectoryController < ApplicationController
  before_filter :require_user

  def index
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
    else
      @use_search = true
      directory_search_setup
    end
  end

  def search
    directory_search_setup
    render :partial => "search_results"
  end
  
  def restaurants
    @restaurants = Restaurant.all
  end

end
