class Soapbox::ALaMinuteAnswersController < ApplicationController
  
  def show
    @answer = ALaMinuteAnswer.find(params[:id])
    @question = @answer.a_la_minute_question
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

end
