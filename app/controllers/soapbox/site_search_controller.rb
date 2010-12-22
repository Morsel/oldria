class Soapbox::SiteSearchController < ApplicationController

  layout 'soapbox_site_search'

  def show
    @key = params[:query].try(:strip)
    @all_entries = []

    unless @key.blank?
      TrendQuestion.soapbox_entry_published.subject_like_or_display_message_like(@key).
        all(:include => :soapbox_entry).each do |entry|
        @all_entries << [entry, :trend_question]
      end

      Admin::Qotd.soapbox_entry_published.message_like_or_display_message_like(@key).
        all(:include => :soapbox_entry).each do |entry|
        @all_entries << [entry, :qotd]
      end

      Comment.search_trend_question_comments(@key).each do |entry|
        @all_entries << [entry, :trend_question_comment]
      end

      Comment.search_qotd_comments(@key).each do |entry|
        @all_entries << [entry, :qotd_comment]
      end

      @all_entries = @all_entries.paginate(:page => params[:page])
    end


    @qotds_found = @all_entries.select {|res, type| type == :qotd }.map(&:first)
    @trend_questions_found = @all_entries.select {|res, type| type == :trend_question }.map(&:first)
    @qotd_comments_found = @all_entries.select {|res, type| type == :qotd_comment }.map(&:first)
    @trend_question_comments_found = @all_entries.select {|res, type| type == :trend_question_comment }.map(&:first)

    @no_results = @trend_questions_found.empty? && @qotds_found.empty? &&
         @qotd_comments_found.empty? && @trend_question_comments_found.empty?
  end

end
