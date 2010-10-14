class Soapbox::SoapboxController < ApplicationController
  
  layout 'soapbox'
  
  def index
  end

  def directory
    # @restaurants_and_employments = Employment.all(:include => :restaurant, 
    #   :order => "restaurants.name ASC").select { |e| e.employee.prefers_publish_profile? }.group_by(&:restaurant)
    directory_search_setup
    @use_search = true
    render :template => "directory/index"
  end

end
