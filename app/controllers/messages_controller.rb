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
    @messages = current_user.direct_messages
  end

  ##
  # GET /messages/staff_discussions
  def staff_discussions
    @messages = current_user.discussions
  end

  private

  def archived_view?
    return @archived_view if defined?(@archived_view)
    @archived_view = params[:view_all] ? true : false
  end
  helper_method :archived_view?

  def get_message_counts
    @ria_message_count = current_user.messages_from_ria.size
    @private_message_count = current_user.direct_messages.size
    @discussions_count = current_user.discussions.size
  end
end
