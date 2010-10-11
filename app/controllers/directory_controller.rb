class DirectoryController < ApplicationController
  before_filter :require_user
  skip_before_filter :preload_resources, :only => :search

  def index
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = Profile.by_specialty(@specialty).map(&:user)
    else
      @use_search = true
      directory_search_setup
    end
  end

  def search
    search_setup(nil, :include => [:restaurant, :employee, :restaurant_role])
    render :partial => "search_results"
  end

end
