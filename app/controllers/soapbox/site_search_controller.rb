class Soapbox::SiteSearchController < ApplicationController

  layout 'soapbox_site_search'

  def show
    @key = params[:query].try(:strip)
    @no_key = params[:query].nil?
    @no_results = true
    @all_entries = []

    return if @no_key

    unless @key.blank?
      search_qotds_and_trends_entities
      search_btl_entities
      search_users
      search_restaurants

      @all_entries = @all_entries.uniq.paginate(:page => params[:page])

      @qotds_found = @all_entries.select {|res, type| type == :qotd }.map(&:first)
      @qotd_comments_found = @all_entries.select {|res, type| type == :qotd_comment }.map(&:first)

      @trend_questions_found = @all_entries.select {|res, type| type == :trend_question }.map(&:first)
      @trend_question_comments_found = @all_entries.select {|res, type| type == :trend_question_comment }.map(&:first)

      @btl_questions_found = @all_entries.select {|res, type| type == :btl_question }.map(&:first)
      @btl_answers_found = @all_entries.select {|res, type| type == :btl_answer }.map(&:first)

      @users_found = @all_entries.select {|res, type| type == :user }.map(&:first)

      @restaurants_found = @all_entries.select {|res, type| type == :restaurant }.map(&:first)

      @no_results = @trend_questions_found.empty? && @qotds_found.empty? &&
        @qotd_comments_found.empty? && @trend_question_comments_found.empty? &&
        @btl_questions_found.empty? && @btl_answers_found.empty? &&
        @users_found.empty? && @restaurants_found.empty?
    end
  end

  protected

  def search_qotds_and_trends_entities
    TrendQuestion.search(:subject_or_display_message_like=>@key).relation.
      all(:include => :soapbox_entry).each do |entry|
      @all_entries << [entry, :trend_question]
    end

    Comment.search_trend_question_comments(@key).each do |entry|
      @all_entries << [entry, :trend_question_comment]
    end

    Admin::Qotd.search(:message_or_display_message_like=>@key).
      all(:include => :soapbox_entry).each do |entry|
      @all_entries << [entry, :qotd]
    end

    Comment.search_qotd_comments(@key).each do |entry|
      @all_entries << [entry, :qotd_comment]
    end
  end

  def search_btl_entities
    ProfileQuestion.answered_by_premium_users.search(:title_like=>@key).all.each do |entry|
      @all_entries << [entry, :btl_question]
    end
    ProfileAnswer.from_premium_users.search(:answer_like=>@key).all(:include => :profile_question).each do |entry|
      @all_entries << [entry, :btl_answer]
    end
  end

  def search_users
    User.extended_find(@key).each do |entry|
      @all_entries << [entry, :user]
    end
  end

  def search_restaurants
    Restaurant.extended_find(@key).each do |entry|
      @all_entries << [entry, :restaurant]
    end
  end

end
