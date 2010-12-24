class MediaRequestDiscussionsController < ApplicationController
  before_filter :require_user
  before_filter :find_media_request_discussion

  def show
    @comments = @media_request_discussion.comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?)
    build_comment
  end

  def update
    if @media_request_discussion.update_attributes(params[:media_request_discussion])
      flash[:notice] = "Cool. That worked!"
      redirect_to @media_request_discussion
    else
      render :show
    end
  end

  private

  def find_media_request_discussion
    @media_request_discussion = MediaRequestDiscussion.find(params[:id])
    @media_request = @media_request_discussion.media_request
  end

  def build_comment
    @comment = @media_request_discussion.comments.build
    @comment.attachments.build
    @comment.user = current_user
    @comment_resource = [@media_request_discussion, @comment]
  end

end
