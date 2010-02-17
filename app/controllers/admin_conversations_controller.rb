class AdminConversationsController < ApplicationController
  before_filter :require_user

  def show
    @admin_conversation = Admin::Conversation.find(params[:id], :include => :admin_message)
    @comments = @admin_conversation.comments.all(:include => :user).reject(&:new_record?)
    build_comment
  end

  private

  def build_comment
    @comment = @admin_conversation.comments.build(:user => current_user)
    @comment_resource = [@admin_conversation, @comment]
  end
end
