class InboxesController < ApplicationController
  before_filter :require_user

  ##
  # GET /inbox
  def show
    @messages = current_user.inbox_messages
  end
end
