class Soapbox::TopicsController < ApplicationController
  
  def show
    if params[:user_id]
      @user = User.find(params[:user_id])
      @topic = Topic.find(params[:id])
      is_self = can? :manage, @user
      @previous = @topic.previous_for_user(@user, is_self)
      @next = @topic.next_for_user(@user, is_self)

      @questions_by_chapter = @user.profile_questions.for_chapter(@topic.chapters.map(&:id)).all(:include => :chapter,
                                                                              :order => "chapters.position, chapters.id").
                                                                              group_by(&:chapter)

      render :template => 'questions/chapters'
    else
      @topic = Topic.find(params[:id])
      @answers = ProfileAnswer.for_topic(@topic).all(:limit => 10, :order => "created_at DESC")

      @previous = @topic.previous
      @next = @topic.next
    end
  end

end
