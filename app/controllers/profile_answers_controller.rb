class ProfileAnswersController < ApplicationController
  
  before_filter :require_user
  skip_before_filter :load_random_btl_question
  
  def create
    respond_to do |format|
      format.html do
        # the regular form submits a hash of question ids with their answers
        for id in params[:profile_question].keys
          @question = ProfileQuestion.find(id)
          answer = @question.find_or_build_answer_for(current_user)
          answer.answer = params[:profile_question][id][:answer]
          answer.post_to_facebook = params[:profile_question][id][:post_to_facebook]
          answer.share_url = soapbox_user_questions_url(answer.user, :chapter_id => answer.profile_question.chapter) 
          answer.save # if it doesn't save, the answer was blank, and we can ignore it
        end

        flash[:notice] = "Your answers have been saved"
          redirect_to user_questions_path(:user_id => current_user.id, 
                                          :chapter_id => @question.chapter.id)
      end

      format.js do 
        @answer = ProfileAnswer.new(params[:profile_answer].merge(:user_id => current_user.id))
        @question = @answer.profile_question

        if @answer.save
          new_question = ProfileQuestion.for_user(current_user).random.reject { |q| q.answered_by?(current_user) }.first
          render :partial => "shared/btl_game", :locals => { :question => new_question } and return
        else
          render :partial => "shared/btl_game", :locals => { :question => @question } and return
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
