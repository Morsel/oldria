class Soapbox::SoapboxEntriesController < Soapbox::SoapboxController
  
  before_filter :hide_flashes
  before_filter :load_past_features, :only => [:index, :show]
  
  def index
    @main_feature = SoapboxEntry.main_feature
    @main_feature_comments = SoapboxEntry.main_feature_comments if @main_feature

    @secondary_feature = SoapboxEntry.secondary_feature
    @secondary_feature_comments = SoapboxEntry.secondary_feature_comments if @secondary_feature
    
    load_past_features
    @no_sidebar = true
  end

  def show
    entry = SoapboxEntry.find(params[:id], :include => :featured_item)
    @feature = entry.featured_item
    @feature_comments = entry.comments
  end
  
  protected

  def hide_flashes
    @hide_flashes = true
  end

end
