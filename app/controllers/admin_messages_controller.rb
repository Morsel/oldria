class AdminMessagesController < ApplicationController
  skip_before_filter :preload_resources, :only => 'read'

  def show
    @admin_message = Admin::Message.find(params[:id])
  end

  ##
  # PUT /admin_messages/1/read
  # This is meant to be called via AJAX
  def read
    @admin_message = Admin::Message.find(params[:id])

    # Mark either the conversation or the message itself as read by the user
    if @admin_message.recipients_can_reply? && current_user
      conversation = current_user.admin_conversations.find_by_admin_message_id(@admin_message.id)
      conversation && conversation.read_by!(current_user)
    else
      @admin_message.read_by!(current_user)
    end

    render :nothing => true
  end
end
