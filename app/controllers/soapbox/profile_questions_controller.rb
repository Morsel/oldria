class Soapbox::ProfileQuestionsController < ApplicationController

  def index
    @answers = ProfileQuestion.without_travel.answered_by_premium_and_public_users.\
        all(:limit => 50, :order => "profile_answers.created_at DESC").map(&:latest_soapbox_answer).uniq.compact[0...15]
  end

  def show
    @question = ProfileQuestion.find(params[:id])
    @answers = @question.profile_answers.from_premium_users.from_public_users.recently_answered
  end

end
