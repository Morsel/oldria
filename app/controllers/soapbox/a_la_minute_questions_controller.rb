class Soapbox::ALaMinuteQuestionsController < ApplicationController

  def index
    # ALM Questions with a publicly-viewable answer from a premium user
    @questions = ALaMinuteQuestion.most_recent_for_soapbox
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

  def show
    @question = ALaMinuteQuestion.find(params[:id])
    @answers = ALaMinuteAnswer.from_premium_responders.show_public.newest_for(@question)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

end