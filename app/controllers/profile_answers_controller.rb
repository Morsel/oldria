class ProfileAnswersController < ApplicationController
  
  def create
    @user = current_user #FIXME???
    @answer = ProfileAnswer.new(params[:profile_answer].merge(:user_id => @user.id))
    @question = ProfileQuestion.find(@answer.profile_question_id)
    
    if @answer.save
      flash[:notice] = "Your answer has been saved"
      redirect_to user_questions_path(:user_id => @user.id, :chapter_id => @question.chapter.id)
    else
      render :template => "profile_answers/new"
    end
  end
  
end
