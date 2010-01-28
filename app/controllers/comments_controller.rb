class CommentsController < ApplicationController
  before_filter :find_parent

  def create
    @comment = @parent.comments.build(params[:comment])

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
    end
  end
end
