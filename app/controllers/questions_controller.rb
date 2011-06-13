class QuestionsController < ApplicationController
  # include QuestionsHelper

  before_filter :require_user_unless_soapbox
  before_filter :get_user, :except => [:show] # Show view includes many users' responses

  def index
    @chapter = Chapter.find(params[:chapter_id])

    is_self = can? :manage, @user
    @previous = @chapter.previous_for_user(@user, is_self)
    @next = @chapter.next_for_user(@user, is_self)
    @previous_topic = @chapter.topic.previous_for_user(@user, is_self)
    @next_topic = @chapter.topic.next_for_user(@user, is_self)

    @questions = is_self ?
      @chapter.profile_questions.for_user(@user) :
      ProfileQuestion.answered_for_user(@user).for_chapter(params[:chapter_id])
  end

  def show
    @question = ProfileQuestion.find(params[:id])
    @answers = @question.profile_answers.from_premium_users.recently_answered.select { |a| a.user.try(:prefers_publish_profile?) }
  end

  def topics
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

  def chapters
    @topic = Topic.find(params[:topic_id])
    is_self = can? :manage, @user
    @previous = @topic.previous_for_user(@user, is_self)
    @next = @topic.next_for_user(@user, is_self)

    @questions_by_chapter = @user.profile_questions.for_chapter(@topic.chapters.map(&:id)).all(:include => :chapter,
                                                                            :order => "chapters.position, chapters.id").
                                                                            group_by(&:chapter)
  end

  def refresh
    @btl_question = ProfileQuestion.for_user(@user).all({:order => RANDOM_SQL_STRING}).reject { |q| q.answered_by?(@user) }.first
    render :partial => "shared/btl_game", :locals => { :question => @btl_question }
  end

  protected

  def get_user
    @user = User.find(params[:user_id])
  end

end
