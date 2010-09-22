class QuestionsController < ApplicationController
  
  before_filter :require_user
  before_filter :get_user
  
  def index
    @chapter = Chapter.find(params[:chapter_id])
    @previous = @chapter.previous_for_user(@user)
    @next = @chapter.next_for_user(@user)
    @previous_topic = @chapter.topic.previous_for_user(@user)
    @next_topic = @chapter.topic.next_for_user(@user)
    @questions = @user.profile_questions.all(:conditions => { :chapter_id => params[:chapter_id] })
  end

  def topics
    @profile = @user.profile || @user.build_profile
    questions = @user.profile_questions
    @topics = Topic.for_user(@user)
    @chapters_by_topic = Chapter.for_user(@user).group_by(&:topic)
  end
  
  def chapters
    @topic = Topic.find(params[:topic_id])
    @previous = @topic.previous_for_user(@user)
    @next = @topic.next_for_user(@user)
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
