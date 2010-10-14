class SoapboxEntriesController < Soapbox::SoapboxController
  
  before_filter :require_http_authenticated
  before_filter :hide_flashes
  before_filter :load_past_features, :only => [:index, :show]
  
  def index
    @main_feature = SoapboxEntry.main_feature
    @main_feature_comments = SoapboxEntry.main_feature_comments if @main_feature

    @secondary_feature = SoapboxEntry.secondary_feature
    @secondary_feature_comments = SoapboxEntry.secondary_feature_comments if @secondary_feature
    
    @no_sidebar = true
  end

  def show
    entry = SoapboxEntry.find(params[:id], :include => :featured_item)
    @feature = entry.featured_item
    @feature_comments = entry.comments
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

  def hide_flashes
    @hide_flashes = true
  end

end
