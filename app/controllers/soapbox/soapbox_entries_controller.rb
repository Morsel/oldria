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

  def trend
    @questions = SoapboxEntry.trend_question.published.paginate(:page => params[:page], :include => :featured_item)

    @featured_items = @questions.map(&:featured_item)
    @no_sidebar = true
  end

  def qotd
    @questions = SoapboxEntry.qotd.published.paginate(:page => params[:page], :include => :featured_item)

    @featured_items = @questions.map(&:featured_item)
    @no_sidebar = true
  end

  def search
    @key = params[:query]
    @qotds_found = Admin::Qotd.soapbox_entry_published.message_like_or_display_message_like(@key).all(:include => :soapbox_entry)
    @trend_questions_found = TrendQuestion.soapbox_entry_published.subject_like_or_display_message_like(@key).all(:include => :soapbox_entry)

    @qotd_comments_found = Comment.search_qotd_comments(@key)
    @trend_question_comments_found = Comment.search_trend_question_comments(@key)

    @no_sidebar = true

    @no_results = @trend_questions_found.empty? && @qotds_found.empty? &&
         @qotd_comments_found.empty? && @trend_question_comments_found.empty?

    render 'soapbox/soapbox_entries/search', :layout => 'soapbox_search_results'
  end

  protected

  def hide_flashes
    @hide_flashes = true
  end

end
