class TrendQuestionDiscussionsController < ApplicationController
  before_filter :require_user

  def show
    @trend_question_discussion = TrendQuestionDiscussion.find(params[:id])
    @trend_question = @trend_question_discussion.trend_question
    @comments = @trend_question_discussion.comments.reject(&:new_record?)
    build_comment
  end

  private

  def build_comment
    @comment = @trend_question_discussion.comments.build(:user => current_user)
    @comment.attachments.build
    @comment_resource = [@trend_question_discussion, @comment]
  end

end
