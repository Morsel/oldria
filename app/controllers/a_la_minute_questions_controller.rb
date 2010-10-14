class ALaMinuteQuestionsController < ApplicationController
  def show_as_public
    restaurant = Restaurant.find(params[:restaurant_id])
    question = ALaMinuteQuestion.find(params[:id])
    answers_for_question = question.answers_for(restaurant)

    answers_for_question.each do |answer|
      answer.update_attributes(:show_as_public => params[:a_la_minute_answer][:show_as_public])
    end

    if request.xhr?
      render :nothing => true
    else
      redirect_to restaurant_path(restaurant)
    end
  end
end