class Soapbox::ALaMinuteAnswersController < ApplicationController
  
  def show
    @answer = ALaMinuteAnswer.find(params[:id])
    @question = @answer.a_la_minute_question
    @sidebar_questions = ALaMinuteQuestion.all(:order => "question")        
    @promotions = @answer.restaurant.promotions.all\
    	(:conditions=>["DATE(created_at) > DATE(?) or DATE(created_at) = DATE(?) ", Time.now,Time.now],:order => "created_at DESC",:limit=>3)
    @menu_items = @answer.restaurant.menu_items.all\
    	(:conditions=>["DATE(created_at) < DATE(?)", Time.now],:limit=>3,:order=>"menu_items.created_at DESC")
  end

end
