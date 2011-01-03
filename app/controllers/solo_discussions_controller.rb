class SoloDiscussionsController < ApplicationController
  before_filter :require_user
  
  def show
    @discussion = SoloDiscussion.find(params[:id])
    @trend_question = @discussionable = @discussion.trend_question
    @comments = @discussion.comments.reject(&:new_record?)
    build_comment
  end

  def read
    @discussion = SoloDiscussion.find(params[:id])
    @discussion.read_by!(current_user)
    @discussion.trend_question.read_by!(current_user)
    render :nothing => true
  end
  
  private
  
  def build_comment
    @comment = @discussion.comments.build(:user => current_user)
    @comment.attachments.build
    @comment_resource = [@discussion, @comment]
  end

end
