class DiscussionsController < ApplicationController
  before_filter :require_user

  def index
    @discussions = current_user.discussions
  end

  def show
    load_and_authorize_discussion
    @comments = @discussion.posted_comments
    build_comment
  end

  def new
    @discussion = current_user.posted_discussions.build(:user_ids => [current_user.id])
    @users = current_user.coworkers
  end

  def create
    @discussion = current_user.posted_discussions.build(params[:discussion])
    if @discussion.save
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def load_and_authorize_discussion
    @discussion = Discussion.find(params[:id])
    unauthorized! if cannot? :read, @discussion
  end

  def build_comment
    @comment = @discussion.comments.build
    @comment.user = current_user
    @comment.attachments.build
    @comment_resource = [@discussion, @comment]
  end
end
