class Soapbox::ChaptersController < ApplicationController

  def show
    if params[:user_id]
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

      render :template => 'soapbox/chapters/user_show'
    else
      @chapter = Chapter.find(params[:id])
      @questions = @chapter.profile_questions.answered_by_premium_users.uniq

      @next_topic = @chapter.topic.next
      @previous_topic = @chapter.topic.previous
      @next = @chapter.next
      @previous = @chapter.previous
    end
  end

end
