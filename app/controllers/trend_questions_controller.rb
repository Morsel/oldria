class TrendQuestionsController < ApplicationController

  before_filter :require_user
  
  def show
    @trend_question = TrendQuestion.find(params[:id])
    @discussions = @trend_question.admin_discussions.with_replies.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    @discussions = @restaurant.admin_discussions.for_trends.with_replies.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

end
