class ProfileAnswersController < ApplicationController

  before_filter :require_user
  before_filter :require_responder

  skip_before_filter :load_random_btl_question

  def create
    respond_to do |format|
      format.html do
        # the regular form submits a hash of question ids with their answers
        for id in params[:profile_question].keys
          @question = ProfileQuestion.find(id)
          answer = @question.find_or_build_answer_for(@responder)
          answer.answer = params[:profile_question][id][:answer]
          answer.responder = @responder
          answer.save # if it doesn't save, the answer was blank, and we can ignore it
        end

        flash[:notice] = "Your answers have been saved"
        redirect_to send("#{@responder.class.name.downcase}_questions_path".to_sym,
            "#{@responder.class.name.downcase}_id".to_sym => @responder.id,
            :chapter_id => @question.chapter.id)
      end

      format.js do
        @answer = ProfileAnswer.new(params[:profile_answer].merge(:user_id => current_user.id))
        @question = @answer.profile_question

        if @answer.save
          new_question = ProfileQuestion.for_subject(@responder).random.reject { |q| q.answered_by?(@responder) }.first
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
      redirect_to send("#{@answer.responder.class.name.downcase}_questions_path",
                      "#{@answer.responder.class.name.downcase}_id".to_sym => @answer.responder_id,
                      :chapter_id => @question.chapter.id,
                      :anchor => "profile_question_#{@question.id}")
    else
      render :template => "profile_answers/new"
    end
  end

  def destroy
    @answer = ProfileAnswer.find(params[:id])
    @question = @answer.profile_question
    @user = @answer.responder
    flash[:notice] = "Your answer has been deleted"
    @answer.destroy
    redirect_to send("#{@responder.class.name.downcase}_questions_path", "#{@responder.class.name.downcase}_id".to_sym => @responder.id,
                                    :chapter_id => @question.chapter.id,
                                    :anchor => "profile_question_#{@question.id}")
  end

  private

  def require_responder
    if params[:restaurant_id]
      @responder = Restaurant.find(params[:restaurant_id])
    else
      @responder = current_user
    end
  end
end
