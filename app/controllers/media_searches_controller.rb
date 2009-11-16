class MediaSearchesController < ApplicationController
  def show
    @search = Employment.search(params[:search])
    if params[:search]
      @employments = @search.all(:include => [:restaurant, :employee, :restaurant_role])
      @restaurants_and_employees = @employments.group_by(&:restaurant)
    end
  end

end
