class QuestionsController < ApplicationController

  def topics
    @profile = current_user.profile || current_user.build_profile
    questions = current_user.profile_questions
    @topics = questions.map(&:topic).uniq
    @chapters_by_topic = questions.map(&:chapter).uniq.group_by(&:topic)
  end
  
  def chapters
    @topic = Topic.find(params[:topic_id])
    @questions_by_chapter = current_user.profile_questions.all(:conditions => { :chapter_id => @topic.chapters.map(&:id) }).group_by(&:chapter)
  end

end
