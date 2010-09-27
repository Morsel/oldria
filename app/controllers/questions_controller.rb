class QuestionsController < ApplicationController
  
  before_filter :require_user
  before_filter :get_user
  
  def index
    @chapter = Chapter.find(params[:chapter_id])

    is_self = @user == current_user
    @previous = @chapter.previous_for_user(@user, is_self)
    @next = @chapter.next_for_user(@user, is_self)
    @previous_topic = @chapter.topic.previous_for_user(@user, is_self)
    @next_topic = @chapter.topic.next_for_user(@user, is_self)

    @questions = @user == current_user ? 
        @user.profile_questions.for_chapter(params[:chapter_id]) :
        @user.profile_questions.answered_for_chapter(params[:chapter_id])
  end

  def topics
    @profile = @user.profile || @user.build_profile
    questions = @user.profile_questions
    @topics = Topic.for_user(@user)
    @chapters_by_topic = Chapter.for_user(@user).group_by(&:topic)
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
  
  private

  def get_user
    @user = User.find(params[:user_id])
  end

end
