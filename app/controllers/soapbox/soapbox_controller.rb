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
    params[:search] = { :employee_premium_account_equals => true }
    directory_search_setup
    @use_search = true
    render :template => "directory/index"
  end
  
  def directory_search
    params[:search].present? ? 
        params[:search].merge(:employee_premium_account_equals => true) : 
        params[:search] = { :employee_premium_account_equals => true }
    directory_search_setup
    render :partial => "directory/search_results"
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
