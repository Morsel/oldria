class DirectoryController < ApplicationController
  before_filter :require_user
  skip_before_filter :preload_resources, :only => :search

  def index
    @use_search = true
    search_setup(nil, :include => [:restaurant, :employee, :restaurant_role])
  end

  def search
    search_setup(nil, :include => [:restaurant, :employee, :restaurant_role])
    render :partial => "search_results"
  end

end
