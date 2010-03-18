class DirectoryController < ApplicationController
  before_filter :require_user

  def index
    @restaurants = Restaurant.paginate(
                    :order => 'UPPER(name) ASC',
                    :page => params[:page],
                    :include => {:employments => [:employee, :restaurant_role]})
  end

end
