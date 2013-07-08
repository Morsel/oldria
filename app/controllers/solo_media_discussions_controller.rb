class SoloMediaDiscussionsController < ApplicationController

  before_filter :require_user
  before_filter :find_solo_media_discussion
  before_filter :authorize_or_redirect, :only => :show

  def show
    @comments = @solo_media_discussion.comments.all(:include => [:user, :attachments], :order => 'created_at DESC')
    build_comment
  end

  ##
  # PUT /solo_media_discussions/1/read
  # This is meant to be called via AJAX
  def read
    @solo_media_discussion.read_by!(current_user)
    @solo_media_discussion.comments.each do |comment|
      comment.read_by!(current_user) unless comment.read_by?(current_user)
    end
    render :nothing => true
  end

  private

  def find_solo_media_discussion
    @solo_media_discussion = SoloMediaDiscussion.find(params[:id])
    @media_request = @solo_media_discussion.media_request
  end

  def build_comment
    @comment = @solo_media_discussion.comments.build
    @comment.attachments.build
    @comment.user = current_user
    @comment_resource = [@solo_media_discussion, @comment]
  end

  def authorize_or_redirect
    if current_user.media?
      redirect_to mediafeed_discussion_path(@media_request.id,@solo_media_discussion.class.name.pluralize.underscore.downcase, 
                                            @solo_media_discussion.id)
    else
      unauthorized! if cannot? :manage, @solo_media_discussion
    end
  end

end
