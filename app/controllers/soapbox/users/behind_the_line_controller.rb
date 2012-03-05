class Soapbox::Users::BehindTheLineController < ApplicationController

  def topic
    @user = User.find(params[:user_id])
    @topic = Topic.find(params[:id])
    is_self = can? :manage, @user
    @previous = @topic.previous_for_user(@user, is_self)
    @next = @topic.next_for_user(@user, is_self)

    @questions_by_chapter = @user.profile_questions.for_chapter(@topic.chapters.map(&:id)).all(:include => :chapter, :order => "chapters.position, chapters.id").\
        group_by(&:chapter)
  end

  def chapter
    @user = User.find(params[:user_id])
    @chapter = Chapter.find(params[:id])

    is_self = can? :manage, @user
    @previous = @chapter.previous_for_user(@user, is_self)
    @next = @chapter.next_for_user(@user, is_self)
    @previous_topic = @chapter.topic.previous_for_user(@user, is_self)
    @next_topic = @chapter.topic.next_for_user(@user, is_self)

    @questions = is_self ?
        @chapter.profile_questions.for_user(@user) :
        ProfileQuestion.answered_for_user(@user).for_chapter(params[:id])
  end

end
