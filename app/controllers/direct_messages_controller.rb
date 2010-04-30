class DirectMessagesController < ApplicationController
  def new
    @recipient = User.find(params[:user_id])
    @direct_message = @recipient.direct_messages.build
    @direct_message.attachments.build
  end

  def create
    @recipient = User.find(params[:user_id])
    @direct_message = current_user.sent_direct_messages.build(params[:direct_message])
    @direct_message.receiver = @recipient
    if @direct_message.save
      flash[:notice] = "Your message has been sent!"
      redirect_to direct_message_path(@direct_message)
    else
      render :new
    end
  end

  def show
    @current_message = DirectMessage.find(params[:id])
    @direct_message = @current_message.root_message
    @reply_allowed = true
    if current_user == @current_message.receiver || @current_message.sender
      @current_message.read_by!(current_user)
    else
      flash[:error] = "Sorry, this isn't your message."
      redirect_to root_url
    end
  end

  ##
  # PUT /direct_messages/1/read
  # This is meant to be called via AJAX
  def read
    @direct_message = current_user.direct_messages.find(params[:id])
    @direct_message.read_by!(current_user)
    render :nothing => true
  end
end
