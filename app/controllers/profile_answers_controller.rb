class ProfileAnswersController < ApplicationController
  
  before_filter :require_user
  
  def create
    @answer = ProfileAnswer.new(params[:profile_answer].merge(:user_id => current_user.id))
    @question = @answer.profile_question
    
    if @answer.save
      flash[:notice] = "Your answer has been saved"
      redirect_to user_questions_path(:user_id => current_user.id, 
                                      :chapter_id => @question.chapter.id, 
                                      :anchor => "profile_question_#{@question.id}")
    else
      render :template => "profile_answers/new"
    end
  end
  
  def update
    @answer = ProfileAnswer.find(params[:id])
    @question = @answer.profile_question
    if @answer.update_attributes(params[:profile_answer])
      flash[:notice] = "Your answer has been saved"
      redirect_to user_questions_path(:user_id => @answer.user_id, 
                                      :chapter_id => @question.chapter.id, 
                                      :anchor => "profile_question_#{@question.id}")
    else
      render :template => "profile_answers/new"
    end
  end
  
  def destroy
    @answer = ProfileAnswer.find(params[:id])
    @question = @answer.profile_question
    @user = @answer.user
    flash[:notice] = "Your answer has been deleted"
    @answer.destroy
    redirect_to user_questions_path(:user_id => @user.id, 
                                    :chapter_id => @question.chapter.id, 
                                    :anchor => "profile_question_#{@question.id}")
  end
  
end
