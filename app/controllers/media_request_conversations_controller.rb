class MediaRequestConversationsController < ApplicationController
  def show
    @media_request_conversation = MediaRequestConversation.find(params[:id])
    @comments = @media_request_conversation.comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
    build_comment
  end

  def update
    @media_request_conversation = MediaRequestConversation.find(params[:id])
    if @media_request_conversation.update_attributes(params[:media_request_conversation])
      flash[:notice] = "Cool. That worked!"
      redirect_to @media_request_conversation
    else
      render :show
    end
  end
  
  def build_comment
    @comment = @media_request_conversation.comments.build
    @comment.attachments.build
    @comment.user = current_user
    @comment_resource = [@media_request_conversation, @comment]
  end
end
