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
      render :update do |page|
        page.call "close_box"
        page[@quick_reply.message].replace :partial => 'messages/message', :locals => { :message =>  @quick_reply.message }
        page[@quick_reply.message].visual_effect(:highlight, :duration => 5.0)
        page.call "$('.colorbox').unbind().colorbox"
      end
    else
      render :update do |page|
        page.call "post_reply_text"
        page['error_messages'].replace_html error_messages_for :quick_reply
      end
    end
  end
end
