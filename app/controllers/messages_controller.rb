class MessagesController < ApplicationController
  before_filter :require_user
  before_filter :get_message_counts
  before_filter :archived_view?

  ##
  # GET /messages
  def index
    redirect_to ria_messages_path
  end

  ##
  # GET /messages/ria
  def ria
    @messages = archived_view? ? current_user.all_messages : current_user.messages_from_ria
  end

  ##
  # GET /messages/private
  def private
    @messages = if archived_view?
      current_user.root_direct_messages
    else
      current_user.unread_direct_messages.all(:include => [:sender, :users_who_read])
    end
  end

  ##
  # GET /messages/staff_discussions
  def staff_discussions
    @messages = current_user.discussions
  end
end
