class MediaRequestDiscussionsController < ApplicationController

  before_filter :require_user
  before_filter :find_media_request_discussion
  before_filter :authorize_or_redirect, :only => :show

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

  ##
  # PUT /media_request_discussions/1/read
  # This is meant to be called via AJAX
  def read
    @media_request_discussion.read_by!(current_user)
    @media_request_discussion.comments.each do |comment|
      comment.read_by!(current_user) unless comment.read_by?(current_user)
    end
    render :nothing => true
  end

  private

  def find_media_request_discussion
    @media_request_discussion = MediaRequestDiscussion.find(params[:id])
    @media_request = @media_request_discussion.media_request
  end

  def build_comment
    @comment = @media_request_discussion.comments.build
    5.times { @comment.attachments.build }
    @comment.user = current_user
    @comment_resource = [@media_request_discussion, @comment]
  end

  def authorize_or_redirect
    if current_user.media?
      redirect_to mediafeed_discussion_path(@media_request.id, 
                                            @media_request_discussion.class.name.pluralize.underscore.downcase, 
                                            @media_request_discussion.id)
    else
      unauthorized! if cannot? :manage, @media_request_discussion
    end
  end

end
