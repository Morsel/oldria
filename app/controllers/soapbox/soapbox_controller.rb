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

end
