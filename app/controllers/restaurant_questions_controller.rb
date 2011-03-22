class RestaurantQuestionsController < ApplicationController

  before_filter :require_user_unless_soapbox
  before_filter :find_subject

  # Questions for the given chapter, filtered by feature page as needed
  def index
    @chapter = Chapter.find(params[:chapter_id])

    is_self = can? :manage, @restaurant
    @previous = @chapter.previous_for_subject(@subject, is_self)
    @next = @chapter.next_for_subject(@subject, is_self)
    @previous_topic = @chapter.topic.previous_for_subject(@subject, is_self)
    @next_topic = @chapter.topic.next_for_subject(@subject, is_self)

    @questions = is_self ?
        @chapter.profile_questions.for_subject(@subject) :
        @page.present? ?
            ProfileQuestion.answered_for_page(@page, @restaurant).for_chapter(params[:chapter_id]) :
            ProfileQuestion.answered_for_subject(@restaurant).for_chapter(params[:chapter_id])
    render :template => 'questions/index'
  end

  # All topics for the restaurant or restaurant feature page
  def topics
    @restaurant = Restaurant.find(params[:restaurant_id])
    @page = RestaurantFeaturePage.find(params[:page_id]) if params[:page_id].present?
    @subject = @page || @restaurant

    if can? :manage, @restaurant
      @topics = Topic.for_subject(@subject)
      chapters = @topics.collect do |topic|
        topic.chapters.for_subject(@subject).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    else
      @topics = @page.present? ?
                  Topic.answered_for_page(@page, @restaurant) :
                  Topic.answered_for_subject(@restaurant)
      chapters = @topics.collect do |topic|
        @page.present? ?
          topic.chapters.answered_for_page(@page, @restaurant).all(:limit => 3) :
          topic.chapters.answered_for_subject(@restaurant).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    end
    render :template => 'questions/topics'
  end

  # Chapters within a topic, for a restaurant or restaurant feature page
  def chapters
    @topic = Topic.find(params[:topic_id])
    is_self = can? :manage, @restaurant
    @previous = @topic.previous_for_subject(@subject, is_self)
    @next = @topic.next_for_subject(@subject, is_self)

    @questions_by_chapter = @subject.profile_questions.all(:conditions => { :chapter_id => @topic.chapters.map(&:id) }, 
                                                                            :joins => :chapter,
                                                                            :order => "chapters.position, chapters.id").
                                                                            group_by(&:chapter)
    render :template => 'questions/chapters'
  end

  protected

  def find_subject
    @restaurant = Restaurant.find(params[:restaurant_id])
    @page = RestaurantFeaturePage.find(params[:page_id]) if params[:page_id].present?
    @subject = @page || @restaurant
  end

end
