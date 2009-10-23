class MediaRequestConversationsController < ApplicationController
  before_filter :require_user
  before_filter :find_media_request_conversation
  before_filter :require_sender_recipient_or_admin

  def show
    @comments = @media_request_conversation.comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
    build_comment
  end

  def update
    if @media_request_conversation.update_attributes(params[:media_request_conversation])
      flash[:notice] = "Cool. That worked!"
      redirect_to @media_request_conversation
    else
      render :show
    end
  end
  
  private

  def build_comment
    @comment = @media_request_conversation.comments.build
    @comment.attachments.build
    @comment.user = current_user
    @comment_resource = [@media_request_conversation, @comment]
  end

  def find_media_request_conversation
    @media_request_conversation = MediaRequestConversation.find(params[:id])
    @media_request = @media_request_conversation.media_request
  end

  def require_sender_recipient_or_admin
    unless (@media_request_conversation.recipient_id == current_user.id) || (@media_request.sender_id == current_user.id) || current_user.admin?
      flash[:error] = "You aren't allowed to view this page."
      redirect_to root_url
    end
  end
end
