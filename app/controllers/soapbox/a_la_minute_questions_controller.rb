class Soapbox::ALaMinuteQuestionsController < ApplicationController

  def index
    @questions = ALaMinuteQuestion.all(:include => "a_la_minute_answers",
                                       :order => "a_la_minute_answers.created_at DESC",
                                       :limit => 10)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

  def show
    @question = ALaMinuteQuestion.find(params[:id])
    @answers = ALaMinuteAnswer.from_premium_responders.newest_for(@question)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

end