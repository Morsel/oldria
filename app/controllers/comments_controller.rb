class CommentsController < ApplicationController
  before_filter :require_user
  before_filter :find_parent

  def create
    @comment = @parent.comments.build(params[:comment])
    @comment.user_id ||= current_user.id

    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to @parent
    else
      flash[:error] = "Your comment couldn't be saved."
      redirect_to :back
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment].merge(:user_id => current_user.id))
      flash[:notice] = "Updated comment"
      redirect_to ria_messages_path
    else
      render :action => "edit"
    end
  end

  private

  def find_parent
    if params[:media_request_discussion_id]
      @parent = MediaRequestDiscussion.find(params[:media_request_discussion_id])
    elsif params[:discussion_id]
      @parent = Discussion.find(params[:discussion_id])
    elsif params[:admin_conversation_id]
      @parent = Admin::Conversation.find(params[:admin_conversation_id])
    elsif params[:holiday_discussion_id]
      @parent = HolidayDiscussion.find(params[:holiday_discussion_id])
    elsif params[:admin_discussion_id]
      @parent = AdminDiscussion.find(params[:admin_discussion_id])
    end
  end
end
