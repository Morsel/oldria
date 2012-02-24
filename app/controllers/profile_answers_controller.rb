class ProfileAnswersController < ApplicationController

  before_filter :require_user
  before_filter :find_user

  def create
    respond_to do |format|
      format.html do
        # the regular form submits a hash of question ids with their answers
        if params[:profile_question]
          params[:profile_question].each do |id, answer_params|
            @question = ProfileQuestion.find(id)
            answer = @question.find_or_build_answer_for(@user)

            # Only update answers that are new or changed
            if answer.answer != answer_params[:answer]
              answer.answer = answer_params[:answer]

              answer.post_to_facebook = answer_params[:post_to_facebook]
              answer.share_url = soapbox_user_questions_url(answer.user, :chapter_id => answer.profile_question.chapter.id)

              unless answer.save # if it doesn't save, the answer was blank, and we can ignore it
                Rails.logger.error answer.errors.full_messages
              end
            end
          end
        end

        flash[:notice] = "Your answers have been saved"
        redirect_to user_btl_chapter_path(@user, @question.chapter)
      end

      # For the btl-game sidebar widget
      format.js do
        @answer = ProfileAnswer.new(params[:profile_answer].merge(:user => @user))
        @question = @answer.profile_question

        if @answer.save
          new_question = ProfileQuestion.for_subject(@user).random.reject { |q| q.answered_by?(@user) }.first
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
      redirect_to user_btl_chapter_path(@user, @question.chapter, :anchor => "profile_question_#{@question.id}")
    else
      render :template => "profile_answers/new"
    end
  end

  def destroy
    @answer = ProfileAnswer.find(params[:id])
    @question = @answer.profile_question

    if @answer.destroy
      flash[:notice] = "Your answer has been deleted"
      redirect_to user_btl_chapter_path(@user, @question.chapter, :anchor => "profile_question_#{@question.id}")
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

end
