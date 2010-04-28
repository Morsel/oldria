class DirectMessagesController < ApplicationController
  def new
    @recipient = User.find(params[:user_id])
    @direct_message = @recipient.direct_messages.build
  end

  def create
    @recipient = User.find(params[:user_id])
    @direct_message = current_user.sent_direct_messages.build(params[:direct_message])
    @direct_message.receiver = @recipient
    if @direct_message.save
      flash[:notice] = "Your message has been sent!"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @direct_message = DirectMessage.find(params[:id])
    @direct_message.read_by!(current_user)
  end

  def reply
    @original_message = DirectMessage.find(params[:id])
    if @original_message.receiver_id == current_user.id
      @direct_message = @original_message.build_reply
      @recipient = @direct_message.receiver
    else
      flash[:error] = "You can only reply to messages sent to you"
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
