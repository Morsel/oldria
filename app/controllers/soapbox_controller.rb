class SoapboxController < ApplicationController

  #before_filter :load_past_features

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
  end

  protected

  def load_past_features
    @qotds = SoapboxEntry.qotd.published.recent.all(:include => :featured_item).map(&:featured_item)
    @trend_questions = SoapboxEntry.trend_question.published.recent.all(:include => :featured_item).map(&:featured_item)
  end

end
