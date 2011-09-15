class ALaMinuteAnswersController < ApplicationController

  before_filter :require_user
  before_filter :require_restaurant_employee, :only => [:destroy, :bulk_edit, :bulk_update]

  def destroy
    @restaurant.a_la_minute_answers.destroy(params[:id])

    if request.xhr?
      render :nothing => true
    else
      flash[:success] = "Answer removed."
      redirect_to :action => :bulk_edit
    end
  end

  def bulk_edit
    @questions = ALaMinuteQuestion.restaurants
  end

  def bulk_update
    params[:a_la_minute_questions].each do |id, attributes|
      question = ALaMinuteQuestion.find(id)
      old_answer = attributes.delete(:old_answer)

      # create a new answer if the answer has changed
      unless attributes[:answer] == old_answer
        @restaurant.a_la_minute_answers.
          create(attributes.merge(:a_la_minute_question_id => id))
      end

      # update all answers for the question to reflect show_as_public state
      question.answers_for(@restaurant).each do |answer|
        answer.update_attributes(:show_as_public => attributes[:show_as_public].present?)
      end
      flash[:success] = "Your changes have been saved."
    end
    redirect_to :action => :bulk_edit
  end

  private

  def require_restaurant_employee
    @restaurant = Restaurant.find(params[:restaurant_id])
    unless @restaurant.employees.include?(current_user) || current_user.admin?
      flash[:notice] = "You must be an employee of #{@restaurant.name} to answer and edit questions"
      redirect_to restaurants_url and return
    end
    true
  end

  def show_as_public_count_valid?
    params[:a_la_minute_questions].select{|id, attributes| attributes[:show_as_public].present? }.length <= 3
  end
end
