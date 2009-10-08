class CommentsController < ApplicationController
  def create
    if params[:media_request_conversation_id]
      @parent = MediaRequestConversation.find(params[:media_request_conversation_id])
    end
    @comment = @parent.comments.build(params[:comment])
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to @parent
    else
      flash[:error] = "Your comment couldn't be saved."
      redirect_to :back
    end
  end
end
