class RestaurantQuestionsController < ApplicationController

  before_filter :require_user_unless_soapbox

  def topics
    @restaurant = Restaurant.find(params[:restaurant_id])
    @page = RestaurantFeaturePage.find(params[:page_id])
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

end
