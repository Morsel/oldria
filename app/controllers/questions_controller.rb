class QuestionsController < ApplicationController
  
  before_filter :require_user
  before_filter :get_user, :except => :show
  
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
    @answers = @question.profile_answers.all(:order => "created_at DESC")
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
  
  private

  def get_user
    @user = User.find(params[:user_id])
  end

end
