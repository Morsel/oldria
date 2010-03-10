class AdminConversationsController < ApplicationController
  before_filter :require_user

  def show
    load_and_authorize_admin_conversation
    @comments = @admin_conversation.comments.all(:include => :user).reject(&:new_record?)
    build_comment
  end

  private

  def build_comment
    @comment = @admin_conversation.comments.build(:user => current_user)
    @comment.attachments.build if @admin_conversation.admin_message.attachments_allowed?
    @comment_resource = [@admin_conversation, @comment]
  end

  def load_and_authorize_admin_conversation
    @admin_conversation = Admin::Conversation.find(params[:id], :include => :admin_message, :order => 'created_at DESC')
    unauthorized! if cannot? :read, @admin_conversation
  end
end
