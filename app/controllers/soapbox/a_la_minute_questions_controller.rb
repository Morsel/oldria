class Soapbox::ALaMinuteQuestionsController < ApplicationController

  def index
    @answers = ALaMinuteAnswer.from_premium_responders.show_public
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

  def show
    @question = ALaMinuteQuestion.find(params[:id])
    @answers = ALaMinuteAnswer.from_premium_responders.show_public.newest_for(@question)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

end