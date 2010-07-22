class HolidayDiscussionsController < ApplicationController
  
  def show
    @discussion = HolidayDiscussion.find(params[:id])
    @comments = @discussion.comments.all(:include => :user).reject(&:new_record?)
    build_comment
  end
  
  def update
    require_admin
    @discussion = HolidayDiscussion.find(params[:id])
    @discussion.update_attributes(params[:holiday_discussion])
    redirect_to admin_holiday_path(@discussion.holiday)
  end
  
  def read
    discussion = HolidayDiscussion.find(params[:id])
    discussion.read_by!(current_user)
    render :nothing => true
  end
  
  private

  def build_comment
    @comment = @discussion.comments.build(:user => current_user)
    @comment.attachments.build
    @comment_resource = [@discussion, @comment]
  end

end