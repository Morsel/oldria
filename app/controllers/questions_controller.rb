class QuestionsController < ApplicationController
  include QuestionsHelper

  before_filter :require_user_unless_soapbox
  before_filter :get_subject, :except => [:show]

  def index
    @chapter = Chapter.find(params[:chapter_id])

    is_self = can? :manage, @subject
    @previous = @chapter.previous_for_subject(@subject, is_self)
    @next = @chapter.next_for_subject(@subject, is_self)
    @previous_topic = @chapter.topic.previous_for_user(@subject, is_self)
    @next_topic = @chapter.topic.next_for_user(@subject, is_self)

    @questions = is_self ?
      @chapter.profile_questions.for_subject(@subject) :
      ProfileQuestion.answered_for_subject(@subject).for_chapter(params[:chapter_id])
  end

  def show
    @question = ProfileQuestion.find(params[:id])
    @answers = @question.profile_answers.from_premium_subjects.all(:order => "profile_answers.created_at DESC").select { |a| a.responder.try(:prefers_publish_profile?) }
  end

  def topics
    if can? :manage, @subject
      @topics = Topic.for_user(@subject)
      chapters = @topics.collect do |topic|
        topic.chapters.for_subject(@subject).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    else
      @topics = Topic.answered_for_user(@subject)
      chapters = @topics.collect do |topic|
        topic.chapters.answered_for_subject(@subject).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    end
  end

  def chapters
    @topic = Topic.find(params[:topic_id])
    is_self = can? :manage, @subject
    @previous = @topic.previous_for_user(@subject, is_self)
    @next = @topic.next_for_user(@subject, is_self)

    @questions_by_chapter = @subject.profile_questions.all(:conditions => { :chapter_id => @topic.chapters.map(&:id) }, 
                                                                            :joins => :chapter,
                                                                            :order => "chapters.position, chapters.id").
                                                                            group_by(&:chapter)
  end

  def refresh
    @btl_question = ProfileQuestion.for_subject(@subject).all({:order => RANDOM_SQL_STRING}).reject { |q| q.answered_by?(@subject) }.first
    render :partial => "shared/btl_game", :locals => { :question => @btl_question }
  end

  protected

  def get_subject
    @subject = User.find(params[:user_id])
  end

end
