class MessagesController < ApplicationController
  before_filter :require_user
  before_filter :get_message_counts
  before_filter :archived_view?

  ##
  # GET /messages
  def index
    redirect_to media_requests_messages_path
  end

  ##
  # GET /messages/ria
  def ria
    @messages = archived_view? ? current_user.all_messages_from_ria : current_user.messages_from_ria
  end

  ##
  # GET /messages/private
  def private
    @messages = if archived_view?
      current_user.root_direct_messages
    else
      current_user.unread_direct_messages
    end
  end

  ##
  # GET /messages/staff_discussions
  def staff_discussions
    if archived_view?
      @messages = current_user.discussions
    else
      @messages_with_replies = current_user.discussions.with_comments_unread_by(current_user)
      @messages = current_user.discussions.find_unread_by(current_user) - @messages_with_replies
    end
  end

  ##
  # GET /messages/media_requests
  def media_requests
    if archived_view?
      @messages = current_user.viewable_media_request_discussions.sort { |a, b| b.created_at <=> a.created_at }
    else
      @messages = current_user.viewable_unread_media_request_discussions.sort { |a, b| b.created_at <=> a.created_at }
    end
  end
end
