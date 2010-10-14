class Soapbox::SoapboxController < ApplicationController
  
  before_filter :load_past_features, :only => [:index, :directory]
  
  layout 'soapbox'
  
  def index
    @home = true
  end

  def directory
    # @restaurants_and_employments = Employment.all(:include => :restaurant, 
    #   :order => "restaurants.name ASC").select { |e| e.employee.prefers_publish_profile? }.group_by(&:restaurant)
    directory_search_setup
    @use_search = true
    render :template => "directory/index"
  end

  protected

  def load_past_features
    @qotds ||= SoapboxEntry.qotd.published.recent.all(:include => :featured_item).map(&:featured_item)
    @trend_questions ||= SoapboxEntry.trend_question.published.recent.all(:include => :featured_item).map(&:featured_item)
  end

end
