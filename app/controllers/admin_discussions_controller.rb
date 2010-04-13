class AdminDiscussionsController < ApplicationController
  before_filter :require_user

  def show
    load_resource
    build_comment
  end

  private

  def load_resource
    @admin_discussion = AdminDiscussion.find(params[:id])
    @discussionable = @admin_discussion.discussionable
    @comments = @admin_discussion.comments.reject(&:new_record?)
  end

  def build_comment
    @comment = @admin_discussion.comments.build(:user => current_user)
    @comment.attachments.build
    @comment_resource = [@admin_discussion, @comment]
  end

end
