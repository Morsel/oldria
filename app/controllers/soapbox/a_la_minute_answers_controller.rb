class Soapbox::ALaMinuteAnswersController < ApplicationController
  
  def show
    @answer = ALaMinuteAnswer.find(params[:id])
    @question = @answer.a_la_minute_question
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
    @other_answers = ALaMinuteAnswer.for_question(@question).from_premium_responders.all(:order => "created_at DESC", :limit => 10).reject { |a| a == @answer }
  end

end
