class Soapbox::ALaMinuteQuestionsController < ApplicationController

  def index
    @questions = ALaMinuteQuestion.all(:include => "a_la_minute_answers",
                                       :order => "a_la_minute_answers.created_at DESC",
                                       :conditions => ["`a_la_minute_answers`.show_as_public = ?", true],
                                       :limit => 10)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

  def show
    @question = ALaMinuteQuestion.find(params[:id])
    @answers = ALaMinuteAnswer.from_premium_responders.show_public.newest_for(@question)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

end