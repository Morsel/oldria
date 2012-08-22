class Soapbox::ALaMinuteQuestionsController < ApplicationController

  def index
    @answers = ALaMinuteAnswer.activated_restaurants.from_premium_responders.paginate(:page => params[:page], :per_page => 5)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

  def show
    @question = ALaMinuteQuestion.find(params[:id])
    @answers =  ALaMinuteAnswer.from_premium_responders.newest_for(@question)
    @answers = @answers.paginate(:page => params[:page], :per_page => 5)
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")
  end

end