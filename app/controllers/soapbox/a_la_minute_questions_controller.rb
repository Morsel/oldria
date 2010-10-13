class Soapbox::ALaMinuteQuestionsController < ApplicationController
  def show
    @question = ALaMinuteQuestion.find(params[:id])
    @answers = ALaMinuteAnswer.newest_for(@question)
  end
end