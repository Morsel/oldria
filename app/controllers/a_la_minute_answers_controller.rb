class ALaMinuteAnswersController < ApplicationController
  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.a_la_minute_answers.destroy(params[:id])

    if request.xhr?
      render :nothing => true
    else
      flash[:success] = "Answer removed."
      redirect_to :action => :bulk_edit
    end
  end

  def bulk_edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @questions = ALaMinuteQuestion.restaurants
  end

  def bulk_update
    @restaurant = Restaurant.find(params[:restaurant_id])

    if show_as_public_count_valid?
      params[:a_la_minute_questions].each do |id, attributes|
        question = ALaMinuteQuestion.find(id)
        old_answer = attributes.delete(:old_answer)

        # create a new answer if the answer has changed
        unless attributes[:answer] == old_answer
          @restaurant.a_la_minute_answers.create(
              attributes.merge(:a_la_minute_question_id => id))
        end

        # update all answers for the question to reflect show_as_public state
        question.answers_for(@restaurant).each do |answer|
          answer.update_attributes(:show_as_public => attributes[:show_as_public].present?)
        end
        flash[:success] = "Your changes have been saved."
      end
      redirect_to :action => :bulk_edit
    else
      flash.now[:error] = "Sorry, only 3 answers can be displayed on your Soapbox Profile page."
      @questions = ALaMinuteQuestion.restaurants
      render :bulk_edit
    end

  end

  # sent from the eip javascript function
  # see http://josephscott.org/code/javascript/jquery-edit-in-place/ for
  # parameters
  def edit_in_place
    id = params[:id].split("_")[-1]
    @question = ALaMinuteQuestion.find_by_id(id)
    @restaurant = Restaurant.find_by_id(params[:data].split("=").last)
    if @restaurant && @question
      @answer = ALaMinuteAnswer.create(:answer => params[:new_value].strip,
          :responder => @restaurant, :a_la_minute_question => @question)
    end
    if @restaurant && @question && @answer.valid?
      render :text => {:is_error => false, :error_text => nil, :html => @answer.answer}.to_json
    else
      render :text => {:is_error => true, :error_text => "Error updating answer",
          :html => params[:orig_value]}.to_json
    end
  end

  private

  def show_as_public_count_valid?
    params[:a_la_minute_questions].select{|id, attributes| attributes[:show_as_public].present? }.length <= 3
  end
end