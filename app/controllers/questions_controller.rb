class QuestionsController < ApplicationController
  include QuestionsHelper

  before_filter :require_user_unless_soapbox
  before_filter :get_subject, :except => :show
  before_filter :get_profile, :only => :topics

  skip_before_filter :load_random_btl_question, :only => [:refresh]

  layout 'application'

  def index
    @chapter = Chapter.find(params[:chapter_id])

    is_self = can_edit_profile_questions(@subject)
    @previous = @chapter.previous_for_subject(@subject, is_self)
    @next = @chapter.next_for_subject(@subject, is_self)
    @previous_topic = @chapter.topic.previous_for_subject(@subject, is_self)
    @next_topic = @chapter.topic.next_for_subject(@subject, is_self)

    @questions = is_self ?
        @chapter.profile_questions.for_subject(@subject) :
        @subject.is_a?(RestaurantFeaturePage) ?
            ProfileQuestion.answered_for_page(@subject, @restaurant).for_chapter(params[:chapter_id]) :
            ProfileQuestion.answered_for_subject(@subject).for_chapter(params[:chapter_id])
  end

  def show
    @question = ProfileQuestion.find(params[:id])
    @answers = @question.profile_answers.from_premium_subjects.all(:order => "profile_answers.created_at DESC").select { |a| a.responder.prefers_publish_profile? }
  end

  def topics
    if can_edit_profile_questions(@subject)
      @topics = Topic.for_subject(@subject)
      chapters = @topics.collect do |topic|
        topic.chapters.for_subject(@subject).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    else
      @topics = @subject.is_a?(RestaurantFeaturePage) ?
                  Topic.answered_for_page(@subject, @restaurant) :
                  Topic.answered_for_subject(@subject)
      chapters = @topics.collect do |topic|
        @subject.is_a?(RestaurantFeaturePage) ?
          topic.chapters.answered_for_page(@subject, @restaurant).all(:limit => 3) :
          topic.chapters.answered_for_subject(@subject).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    end
  end

  def chapters
    @topic = Topic.find(params[:topic_id])
    is_self = can_edit_profile_questions(@subject)
    @previous = @topic.previous_for_subject(@subject, is_self)
    @next = @topic.next_for_subject(@subject, is_self)

    @questions_by_chapter = @subject.profile_questions.
        all(:conditions => { :chapter_id => @topic.chapters.map(&:id) }, :joins => :chapter,
        :order => "chapters.position, chapters.id").
        group_by(&:chapter)
  end

  def refresh
    @btl_question = ProfileQuestion.for_subject(@subject).random.reject { |q| q.answered_by?(@subject) }.first
    render :partial => "shared/btl_game", :locals => { :question => @btl_question }
  end

  protected

  def require_user_unless_soapbox
    params[:controller].match(/soapbox/) ? true : require_user
  end

  def get_subject
    if params[:user_id]
      @subject = User.find(params[:user_id])
    elsif params[:feature_page_id]
      @subject = RestaurantFeaturePage.find(params[:feature_page_id])
      @restaurant = Restaurant.find(params[:restaurant_id])
    else
      @subject = Restaurant.find(params[:restaurant_id])
    end
  end

  def get_profile
    if @subject.is_a? User
      @profile = @subject.profile || @subject.build_profile
    end
  end

end
