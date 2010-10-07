class ALaMinuteAnswersController < ApplicationController
  # sent from the eip javascript function
  # see http://josephscott.org/code/javascript/jquery-edit-in-place/ for
  # parameters
  def edit_in_place
    id = params[:id].split("_")[-1]
    @question = ALaMinuteQuestion.find(id.to_i)
    @restaurant = Restaurant.find(params[:data].split("=").last)
    @answer = ALaMinuteAnswer.create(:answer => params[:new_value].strip,
        :responder => @restaurant, :a_la_minute_question => @question)
    if @answer.valid?
      render :text => {:is_error => false, :error_text => nil, :html => @answer.answer}.to_json
    else
      render :text => {:is_error => true, :error_text => "Error updating answer",
          :html => @answer.answer}.to_json
    end
  end
end