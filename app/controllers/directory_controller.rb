class DirectoryController < ApplicationController
  before_filter :require_user
  skip_before_filter :preload_resources, :only => :search

  def index
    @use_search = true
    search_setup(nil, :include => [:restaurant, :employee, :restaurant_role])
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = Profile.specialties_id_eq(params[:specialty_id]).map(&:user)
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = Profile.cuisines_id_eq(params[:cuisine_id]).map(&:user)
      @restaurants = Restaurant.cuisine_id_eq(params[:cuisine_id])
    else
      @use_search = true
      directory_search_setup
    end
  end

  def search
    directory_search_setup
    render :partial => "search_results"
  end

end
