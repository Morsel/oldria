class Soapbox::TopicsController < ApplicationController
  
  def index
    @topics = Topic.user_topics.without_travel
    chapters = @topics.map(&:chapters)
    @chapters_by_topic = chapters.flatten.group_by(&:topic)
  end

  def show
    @topic = Topic.find(params[:id])
    @previous = @topic.previous
    @next = @topic.next
    @questions_by_chapter = @topic.chapters.map(&:profile_questions).flatten.group_by(&:chapter)
  end

  def chapter
    @chapter = Chapter.find(params[:chapter_id])
    @questions = @chapter.profile_questions

    @next_topic = @chapter.topic.next
    @previous_topic = @chapter.topic.previous
    @next = @chapter.next
    @previous = @chapter.previous
  end

end
