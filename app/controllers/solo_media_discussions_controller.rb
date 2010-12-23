class SoloMediaDiscussionsController < ApplicationController
  before_filter :require_user
  before_filter :find_solo_media_discussion

  def show
    @comments = @solo_media_discussion.comments.all(:include => [:user, :attachments], :order => 'created_at DESC')
    build_comment
  end

  private

  def build_comment
    @comment = @solo_media_discussion.comments.build
    @comment.attachments.build
    @comment.user = current_user
    @comment_resource = [@solo_media_discussion, @comment]
  end

  def find_solo_media_discussion
    @solo_media_discussion = SoloMediaDiscussion.find(params[:id])
    @media_request = @solo_media_discussion.media_request
  end
end
