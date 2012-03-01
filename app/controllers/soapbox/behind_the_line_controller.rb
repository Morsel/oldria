class Soapbox::BehindTheLineController < ApplicationController

  def topic
    @topic = Topic.find(params[:id])
    @answers = ProfileAnswer.for_topic(@topic).from_premium_and_public_users.all(:limit => 10, :order => "created_at DESC")

    @previous = @topic.previous
    @next = @topic.next
  end

  def chapter
    @chapter = Chapter.find(params[:id])
    @questions = @chapter.profile_questions.answered_by_premium_users.uniq

    @next_topic = @chapter.topic.next
    @previous_topic = @chapter.topic.previous
    @next = @chapter.next
    @previous = @chapter.previous
  end

end
