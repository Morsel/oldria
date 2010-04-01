class MessagesController < ApplicationController
  before_filter :require_user

  ##
  # GET /messages
  def index
    @messages = current_user.messages_from_ria
  end
  
  def ria
    render :template => 'messages/index'
  end

  ##
  # GET /messages/archive
  def archive
    @messages = current_user.archived_messages
  end

end
