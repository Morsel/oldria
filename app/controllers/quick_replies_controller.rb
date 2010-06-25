class QuickRepliesController < ApplicationController
  skip_before_filter :preload_resources
  before_filter :require_user
  layout false

  def new
    @quick_reply = QuickReply.new(:message_id => params[:message_id], :message_type => params[:message_type])
  end

  def create
    @quick_reply = QuickReply.new(params[:quick_reply])
    @quick_reply.user = current_user

    if @quick_reply.save
      flash[:notice] = "Successfully created quick reply."
      redirect_to ria_messages_path
    else
      render :new
    end
  end
end
