class Spoonfeed::RestaurantQuestionsController < ApplicationController

  before_filter :require_user

  def index
    @answers = RestaurantQuestion.answered_by_premium_restaurants.all(:limit => 50, :order => "restaurant_answers.created_at DESC").map(&:latest_soapbox_answer).uniq.compact[0...15]
  end

  def show
    @question = RestaurantQuestion.find(params[:id])
    @answers = @question.restaurant_answers.from_premium_restaurants.recently_answered
  end

end
