class Soapbox::SoapboxController < ApplicationController
  
  before_filter :require_http_authenticated
  before_filter :load_past_features, :only => [:index, :directory]
  
  layout 'soapbox'
  
  def index
    @home = true
    @slides = SoapboxSlide.all(:order => "position", :limit => 4)
    @promos = SoapboxPromo.all(:order => "created_at DESC", :limit => 3)
  end

  def directory
    # @restaurants_and_employments = Employment.all(:include => :restaurant, 
    #   :order => "restaurants.name ASC").select { |e| e.employee.prefers_publish_profile? }.group_by(&:restaurant)
    directory_search_setup
    @use_search = true
    render :template => "directory/index"
  end

  protected

  def require_http_authenticated
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == "soapbox" && password == "preview"
      end
    else
      true
    end
  end

  def load_past_features
    @qotds ||= SoapboxEntry.qotd.published.recent.all(:include => :featured_item).map(&:featured_item)
    @trend_questions ||= SoapboxEntry.trend_question.published.recent.all(:include => :featured_item).map(&:featured_item)
  end

end
