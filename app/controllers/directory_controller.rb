class DirectoryController < ApplicationController
  before_filter :require_user

  def index
    search_setup
  end

  def search
    search_setup
    render :partial => "search_results"
  end

end
