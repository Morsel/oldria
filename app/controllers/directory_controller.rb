class DirectoryController < ApplicationController

  def index
    @restaurants = Restaurant.paginate(:order => 'UPPER(name) ASC', :page => params[:page], :include => {:employments => [:employee, :restaurant_role]})
  end

end
