class Soapbox::ChaptersController < ApplicationController

  def show
    @chapter = Chapter.find(params[:id])
    @questions = @chapter.profile_questions.answered_by_premium_users.uniq

    @next_topic = @chapter.topic.next
    @previous_topic = @chapter.topic.previous
    @next = @chapter.next
    @previous = @chapter.previous
  end

end
