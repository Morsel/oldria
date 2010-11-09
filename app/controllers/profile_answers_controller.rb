class ProfileAnswersController < ApplicationController
  
  before_filter :require_user
  
  def create
    @answer = ProfileAnswer.new(params[:profile_answer].merge(:user_id => current_user.id))
    @question = @answer.profile_question
    
    respond_to do |format|
      format.js do 
        if @answer.save
          new_question = ProfileQuestion.for_user(current_user).random.reject { |q| q.answered_by?(current_user) }.first
          render :partial => "shared/btl_game", :locals => { :question => new_question } and return
        else
          render :partial => "shared/btl_game", :locals => { :question => @question } and return
        end
      end
      
      format.html do
        if @answer.save
          flash[:notice] = "Your answer has been saved"
          redirect_to user_questions_path(:user_id => current_user.id, 
            :chapter_id => @question.chapter.id, 
            :anchor => "profile_question_#{@question.id}")
        else
          render :template => "profile_answers/new"
        end
      end
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
