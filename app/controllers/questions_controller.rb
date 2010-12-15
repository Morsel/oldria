class QuestionsController < ApplicationController

  before_filter :require_user_unless_soapbox
  before_filter :get_user, :except => :show
  skip_before_filter :load_random_btl_question, :only => [:refresh]

  layout 'application'

  def index
    @chapter = Chapter.find(params[:chapter_id])

    is_self = @user == current_user
    @previous = @chapter.previous_for_user(@user, is_self)
    @next = @chapter.next_for_user(@user, is_self)
    @previous_topic = @chapter.topic.previous_for_user(@user, is_self)
    @next_topic = @chapter.topic.next_for_user(@user, is_self)

    @questions = is_self ?
        @user.profile_questions.for_chapter(params[:chapter_id]) :
        ProfileQuestion.answered_for_user(@user).for_chapter(params[:chapter_id])
  end

  def show
    @question = ProfileQuestion.find(params[:id])
    @answers = @question.profile_answers.from_premium_users.all(:order => "profile_answers.created_at DESC").select { |a| a.user.prefers_publish_profile? }
  end

  def topics
    @profile = @user.profile || @user.build_profile
    if @user == current_user
      @topics = Topic.for_user(@user)
      chapters = []
      for topic in @topics
        chapters << topic.chapters.for_user(@user).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    else
      @topics = Topic.answered_for_user(@user)
      chapters = []
      for topic in @topics
        chapters << topic.chapters.answered_for_user(@user).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    end
  end

  def chapters
    @topic = Topic.find(params[:topic_id])
    is_self = @user == current_user
    @previous = @topic.previous_for_user(@user, is_self)
    @next = @topic.next_for_user(@user, is_self)

    @questions_by_chapter = @user.profile_questions.
        all(:conditions => { :chapter_id => @topic.chapters.map(&:id) }, :joins => :chapter,
        :order => "chapters.position, chapters.id").
        group_by(&:chapter)
  end

  def refresh
    @btl_question = ProfileQuestion.for_user(current_user).random.reject { |q| q.answered_by?(current_user) }.first
    render :partial => "shared/btl_game", :locals => { :question => @btl_question }
  end

  def search
    @key = params[:query].strip
    @all_entries = []

    unless @key.empty?
      ProfileQuestion.answered.title_like(@key).each do |entry|
        @all_entries << [entry, :question]
      end

      ProfileAnswer.answer_like(@key).all(:include => :profile_question).each do |entry|
        @all_entries << [entry, :answer]
      end
    end

    @all_entries      = @all_entries.paginate(:page => params[:page])
    @questions_found  = @all_entries.select {|res, type| type == :question }.map(&:first)
    @answers_found    = @all_entries.select {|res, type| type == :answer }.map(&:first)

    @no_sidebar = true
    @no_results = @questions_found.empty? && @answers_found.empty?

    render :layout => 'soapbox_search_results'
  end

  protected

  def require_user_unless_soapbox
    params[:controller].match(/soapbox/) ? true : require_user
  end

  def get_user
    @user = User.find(params[:user_id])
  end

end
