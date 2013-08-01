class Soapbox::ALaMinuteAnswersController < ApplicationController
  
  def show
  	@soapbox_keywordable_id =   params[:id]
    @soapbox_keywordable_type = 'ALaMinuteAnswer' 
    @answer = ALaMinuteAnswer.find(params[:id])
    @restaurant = @answer.restaurant.id
    @question = @answer.a_la_minute_question
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")        
    @promotions = @answer.restaurant.promotions.all(:conditions=>["DATE(start_date) >=  DATE(?)", Time.now],:order => "created_at DESC",:limit=>3)
    @menu_items = @answer.restaurant.menu_items.all(:limit=>3,:order=>"menu_items.created_at DESC")
    @answers =  @answer.restaurant.a_la_minute_answers.all(:limit=>3,:order => "a_la_minute_answers.created_at DESC",:conditions=>["DATE(a_la_minute_answers.created_at) = DATE(?) and a_la_minute_answers.id <> ?", Time.now,@answer.id])

  end

end
