class QuestionsController < ApplicationController
  
  def index
    @chapter = Chapter.find(params[:chapter_id])
    @questions = current_user.profile_questions.all(:conditions => { :chapter_id => params[:chapter_id] })
  end

  def topics
    @profile = current_user.profile || current_user.build_profile
    questions = current_user.profile_questions
    @topics = Topic.for_user(current_user)
    @chapters_by_topic = Chapter.for_user(current_user).group_by(&:topic)
  end
  
  def chapters
    @topic = Topic.find(params[:topic_id])
    @previous = @topic.previous_for_user(current_user)
    @next = @topic.next_for_user(current_user)
    @questions_by_chapter = current_user.profile_questions.all(:conditions => { :chapter_id => @topic.chapters.map(&:id) }).group_by(&:chapter)
  end

end
