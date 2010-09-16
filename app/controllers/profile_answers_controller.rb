class ProfileAnswersController < ApplicationController
  
  before_filter :require_user
  
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
  
  def update
    @answer = ProfileAnswer.find(params[:id])
    @question = ProfileQuestion.find(@answer.profile_question_id)
    if @answer.update_attributes(params[:profile_answer])
      flash[:notice] = "Your answer has been saved"
      redirect_to user_questions_path(:user_id => @answer.user_id, :chapter_id => @question.chapter.id)
    else
      render :template => "profile_answers/new"
    end
  end
  
end
