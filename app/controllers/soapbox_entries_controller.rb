class SoapboxEntriesController < ApplicationController
  before_filter :require_http_authenticated
  before_filter :hide_flashes

  def index
    @main_feature = SoapboxEntry.main_feature
    @main_feature_comments = SoapboxEntry.main_feature_comments if @main_feature

    @secondary_feature = SoapboxEntry.secondary_feature
    @secondary_feature_comments = SoapboxEntry.secondary_feature_comments if @secondary_feature

    load_past_features
  end

  def show
    entry = SoapboxEntry.find(params[:id], :include => :featured_item)
    @feature = entry.featured_item
    @feature_comments = entry.comments
    load_past_features
  end
  
  protected

  def load_past_features
    @qotds = SoapboxEntry.qotd.published.recent.all(:include => :featured_item).map(&:featured_item)
    @trend_questions = SoapboxEntry.trend_question.published.recent.all(:include => :featured_item).map(&:featured_item)
  end

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
