class Users::BehindTheLineController < ApplicationController
  
  before_filter :require_user
  before_filter :get_user

  def index
    if can? :manage, @user
      @topics = Topic.for_user(@user)
      chapters = @topics.collect do |topic|
        topic.chapters.for_user(@user).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    else
      @topics = Topic.answered_for_user(@user)
      chapters = @topics.collect do |topic|
        topic.chapters.answered_for_user(@user).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    end
  end

  def topic
    @topic = Topic.find(params[:id])
    is_self = can? :manage, @user
    @previous = @topic.previous_for_user(@user, is_self)
    @next = @topic.next_for_user(@user, is_self)

    @questions_by_chapter = @user.profile_questions.for_chapter(@topic.chapters.map(&:id)).all(:include => :chapter,
                                                                            :order => "chapters.position, chapters.id").
                                                                            group_by(&:chapter)
  end

  def chapter
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

  protected

  def get_user
    @user = User.find(params[:user_id])
  end
end
