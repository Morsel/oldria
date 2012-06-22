class Restaurants::BehindTheLineController < ApplicationController

  before_filter :require_user
  before_filter :find_restaurant_and_page

  def index
    if can? :manage, @restaurant
      @topics = @page.present? ? RestaurantTopic.for_page(@page) : RestaurantTopic.for_restaurant(@restaurant)
      chapters = @topics.collect do |topic|
        @page.present? ?
            topic.chapters.for_page(@page).all(:limit => 3) :
            topic.chapters.for_restaurant(@restaurant).all(:limit => 3)
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

  def topic
    @topic = Topic.find(params[:id])
    is_self = can? :manage, @restaurant
    @previous = @topic.previous_for_context(@restaurant, @page, is_self)
    @next = @topic.next_for_context(@restaurant, @page, is_self)

    @questions_by_chapter = @subject.questions(:conditions => { :chapter_id => @topic.chapters.map(&:id) },
                                                                :include => :chapter,
                                                                :order => "chapters.position, chapters.id").
                                                                group_by(&:chapter)
  end

  def chapter
    @chapter = Chapter.find(params[:id])

    is_self = can? :manage, @restaurant
    @previous = @chapter.previous_for_context(@restaurant, @page, is_self)
    @next = @chapter.next_for_context(@restaurant, @page, is_self)
    @previous_topic = @chapter.topic.previous_for_context(@restaurant, @page, is_self)
    @next_topic = @chapter.topic.next_for_context(@restaurant, @page, is_self)

    @questions = is_self ?
        RestaurantQuestion.for_chapter(@chapter) :
        @page.present? ?
            RestaurantQuestion.answered_for_page(@page, @restaurant).for_chapter(params[:id]) :
            RestaurantQuestion.answered_for_restaurant(@restaurant).for_chapter(params[:id])
  end

  protected

  def find_restaurant_and_page
    @restaurant = Restaurant.find(params[:restaurant_id])
    @page = RestaurantFeaturePage.find(params[:page_id]) if params[:page_id].present?
    @subject = @page || @restaurant
  end

end
