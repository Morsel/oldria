class RestaurantQuestionsController < ApplicationController

  before_filter :require_user_unless_soapbox
  before_filter :find_subject

  # Questions for the given chapter, filtered by feature page as needed
  def index
    @chapter = Chapter.find(params[:chapter_id])

    is_self = can? :manage, @restaurant
    @previous = @chapter.previous_for_context(@subject, is_self)
    @next = @chapter.next_for_context(@subject, is_self)
    @previous_topic = @chapter.topic.previous_for_context(@subject, is_self)
    @next_topic = @chapter.topic.next_for_context(@subject, is_self)

    @questions = is_self ?
        RestaurantQuestion.for_chapter(@chapter) : # FIXME: should this filter by page too?
        @page.present? ?
            RestaurantQuestion.answered_for_page(@page, @restaurant).for_chapter(params[:chapter_id]) :
            RestaurantQuestion.answered_for_restaurant(@restaurant).for_chapter(params[:chapter_id])
  end

  # All topics for the restaurant or restaurant feature page
  def topics
    @restaurant = Restaurant.find(params[:restaurant_id])
    @page = RestaurantFeaturePage.find(params[:page_id]) if params[:page_id].present?
    @subject = @page || @restaurant

    if can? :manage, @restaurant
      @topics = @page.present? ? RestaurantTopic.for_page(@subject) : RestaurantTopic.for_restaurant(@subject)
      chapters = @topics.collect do |topic|
        @page.present? ?
            topic.chapters.for_page(@subject).all(:limit => 3) :
            topic.chapters.for_restaurant(@subject).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    else
      @topics = @page.present? ?
                  RestaurantTopic.answered_for_page(@page, @restaurant) :
                  RestaurantTopic.answered_for_restaurant(@restaurant)
      chapters = @topics.collect do |topic|
        @page.present? ?
          topic.chapters.answered_for_page(@page, @restaurant).all(:limit => 3) :
          topic.chapters.answered_for_restaurant(@restaurant).all(:limit => 3)
      end
      @chapters_by_topic = chapters.flatten.group_by(&:topic)
    end
  end

  # Chapters within a topic, for a restaurant or restaurant feature page
  def chapters
    @topic = Topic.find(params[:topic_id])
    is_self = can? :manage, @restaurant
    @previous = @topic.previous_for_context(@restaurant, @page, is_self)
    @next = @topic.next_for_context(@restaurant, @page, is_self)

    @questions_by_chapter = @subject.questions(:conditions => { :chapter_id => @topic.chapters.map(&:id) },
                                                                :joins => :chapter,
                                                                :order => "chapters.position, chapters.id").
                                                                group_by(&:chapter)
  end

  protected

  def find_subject
    @restaurant = Restaurant.find(params[:restaurant_id])
    @page = RestaurantFeaturePage.find(params[:page_id]) if params[:page_id].present?
    @subject = @page || @restaurant
  end

end
