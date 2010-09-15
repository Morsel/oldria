class ProfileAnswersController < ApplicationController
  
  def create
    @answer = ProfileAnswer.new(params[:profile_answer].merge(:user_id => current_user.id))
    @question = ProfileQuestion.find(@answer.profile_question_id)
    
    if @answer.save
      flash[:notice] = "Your answer has been saved"
      redirect_to my_profile_questions_path(:chapter_id => @question.chapter.id)
    else
      render :template => "profile_answers/new"
    end
  end
  
end
