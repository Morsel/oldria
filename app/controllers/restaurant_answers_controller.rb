class RestaurantAnswersController < ApplicationController

  before_filter :require_user
  before_filter :find_and_authorize_restaurant, :except => [:show]

  def show
    @answer = RestaurantAnswer.find(params[:id])
    @question = @answer.restaurant_question
    @other_answers = @question.restaurant_answers.from_premium_restaurants.recently_answered - [@answer]
  end

  def create
    # the form submits a hash of question ids with their answers
    if params[:restaurant_question]
      params[:restaurant_question].each do |id, answer_params|
        @question = RestaurantQuestion.find(id)
        answer = @question.find_or_build_answer_for(@restaurant)

        # Only update answers that are new or changed
        if answer.answer != answer_params[:answer]
          answer.answer = answer_params[:answer]

          unless answer.save # if it doesn't save, the answer was blank, and we can ignore it
            Rails.logger.error answer.errors.full_messages
          end
        end
      end
    end

    flash[:notice] = "Your answers have been saved"
    redirect_to restaurant_questions_path(@restaurant, :chapter_id => @question.chapter.id)
  end

  def destroy
    @answer = RestaurantAnswer.find(params[:id])
    @question = @answer.restaurant_question

    if @answer.destroy
      flash[:notice] = "Your answer has been deleted"
      redirect_to restaurant_questions_path(:restaurant_id => @restaurant.id, 
                                      :chapter_id => @question.chapter.id, 
                                      :anchor => "restaurant_question_#{@question.id}")
    end
  end

  private

  def find_and_authorize_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    unauthorized! unless can? :manage, @restaurant
  end

end
