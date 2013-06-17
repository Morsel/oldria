class Spoonfeed::ALaMinuteController < ApplicationController

  before_filter :require_user

  def index
    @keywordable_type = 'ALaMinuteAnswer' 
    @answers = ALaMinuteAnswer.from_premium_responders.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

  def answers
	  @keywordable_id =  params[:question_id]
    @keywordable_type = 'ALaMinuteQuestion' 
    @question = ALaMinuteQuestion.find(params[:question_id])
    @answers = @question.a_la_minute_answers.from_premium_responders.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

end
