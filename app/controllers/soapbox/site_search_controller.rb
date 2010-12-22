class Soapbox::SiteSearchController < ApplicationController

  layout 'soapbox_site_search'

  def show
    @key = params[:query].try(:strip)
    @all_entries = []

    unless @key.blank?
      search_qotds_and_trends_entities
      search_btl_entities

      @all_entries = @all_entries.paginate(:page => params[:page])

      @qotds_found = @all_entries.select {|res, type| type == :qotd }.map(&:first)
      @trend_questions_found = @all_entries.select {|res, type| type == :trend_question }.map(&:first)
      @qotd_comments_found = @all_entries.select {|res, type| type == :qotd_comment }.map(&:first)
      @trend_question_comments_found = @all_entries.select {|res, type| type == :trend_question_comment }.map(&:first)

      @btl_questions_found = @all_entries.select {|res, type| type == :btl_question }.map(&:first)
      @btl_answers_found = @all_entries.select {|res, type| type == :btl_answer }.map(&:first)

      @no_results = @trend_questions_found.empty? && @qotds_found.empty? &&
        @qotd_comments_found.empty? && @trend_question_comments_found.empty? &&
        @btl_questions_found.empty? && @btl_answers_found.empty?
    end

  end

  private

  def search_qotds_and_trends_entities
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
  end

  def search_btl_entities
    ProfileQuestion.answered_by_premium_subjects.title_like(@key).all.each do |entry|
      @all_entries << [entry, :btl_question]
    end
    ProfileAnswer.from_premium_subjects.answer_like(@key).all(:include => :profile_question).each do |entry|
      @all_entries << [entry, :btl_answer]
    end
  end

  def search_users

  end

end
