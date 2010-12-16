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
    @key = params[:query].try(:strip) || ""
    @all_entries = []

    unless @key.empty?
      Admin::Qotd.soapbox_entry_published.message_like_or_display_message_like(@key).
        all(:include => :soapbox_entry).each do |entry|
        @all_entries << [entry, :qotd]
      end

      TrendQuestion.soapbox_entry_published.subject_like_or_display_message_like(@key).
        all(:include => :soapbox_entry).each do |entry|
        @all_entries << [entry, :trend_question]
      end

      Comment.search_qotd_comments(@key).each do |entry|
        @all_entries << [entry, :qotd_comment]
      end

      Comment.search_trend_question_comments(@key).each do |entry|
        @all_entries << [entry, :trend_question_comment]
      end
    end

    @all_entries = @all_entries.paginate(:page => params[:page])
    @qotds_found = @all_entries.select {|res, type| type == :qotd }.map(&:first)
    @trend_questions_found = @all_entries.select {|res, type| type == :trend_question }.map(&:first)
    @qotd_comments_found = @all_entries.select {|res, type| type == :qotd_comment }.map(&:first)
    @trend_question_comments_found = @all_entries.select {|res, type| type == :trend_question_comment }.map(&:first)

    @no_sidebar = true
    @no_results = @trend_questions_found.empty? && @qotds_found.empty? &&
         @qotd_comments_found.empty? && @trend_question_comments_found.empty?

    render :layout => 'soapbox_search_results'
  end

  protected

  def hide_flashes
    @hide_flashes = true
  end

end
