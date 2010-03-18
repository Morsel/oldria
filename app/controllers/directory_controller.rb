class DirectoryController < ApplicationController

  def index
    @restaurants = Restaurant.paginate(:order => 'UPPER(name) ASC', :page => params[:page])
  end

end
