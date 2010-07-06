class AdminDiscussionsController < ApplicationController
  before_filter :require_user

  ##
  # GET /admin_discussions/1
  def show
    load_and_authorize_resource
    build_comment
  end

  ##
  # PUT /admin_discussion/1/read
  # This is meant to be called via AJAX
  def read
    @admin_discussion = AdminDiscussion.find(params[:id])
    @admin_discussion.read_by!(current_user)
    @admin_discussion.discussionable.read_by!(current_user)
    render :nothing => true
  end

  private

  def load_and_authorize_resource
    @admin_discussion = AdminDiscussion.find(params[:id])
    unauthorized! if cannot? :read, @admin_discussion
    @discussionable = @admin_discussion.discussionable
    @comments = @admin_discussion.comments.reject(&:new_record?)
  end

  def build_comment
    @comment = @admin_discussion.comments.build(:user => current_user)
    @comment.attachments.build
    @comment_resource = [@admin_discussion, @comment]
  end

end
