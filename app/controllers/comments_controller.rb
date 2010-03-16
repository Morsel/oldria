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

  private

  def find_parent
    if params[:media_request_conversation_id]
      @parent = MediaRequestConversation.find(params[:media_request_conversation_id])
    elsif params[:discussion_id]
      @parent = Discussion.find(params[:discussion_id])
    elsif params[:admin_conversation_id]
      @parent = Admin::Conversation.find(params[:admin_conversation_id])
    elsif params[:holiday_conversation_id]
      @parent = HolidayConversation.find(params[:holiday_conversation_id])
    end
  end
end
