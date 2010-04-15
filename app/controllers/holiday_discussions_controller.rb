class HolidayDiscussionsController < ApplicationController
  
  def show
    @discussion = HolidayDiscussion.find(params[:id])
    @comments = @discussion.comments.all(:include => :user).reject(&:new_record?)
    build_comment
  end
  
  private

  def build_comment
    @comment = @discussion.comments.build(:user => current_user)
    @comment.attachments.build
    @comment_resource = [@discussion, @comment]
  end

end