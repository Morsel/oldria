class HolidayConversationsController < ApplicationController
  def index
    @holiday_conversations = HolidayConversation.all
  end
  
  def show
    @holiday_conversation = HolidayConversation.find(params[:id])
  end
  
  def new
    @holiday_conversation = HolidayConversation.new
  end
  
  def create
    @holiday_conversation = HolidayConversation.new(params[:holiday_conversation])
    if @holiday_conversation.save
      flash[:notice] = "Successfully created holiday conversation."
      redirect_to @holiday_conversation
    else
      render :action => 'new'
    end
  end
  
  def edit
    @holiday_conversation = HolidayConversation.find(params[:id])
  end
  
  def update
    @holiday_conversation = HolidayConversation.find(params[:id])
    if @holiday_conversation.update_attributes(params[:holiday_conversation])
      flash[:notice] = "Successfully updated holiday conversation."
      redirect_to @holiday_conversation
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @holiday_conversation = HolidayConversation.find(params[:id])
    @holiday_conversation.destroy
    flash[:notice] = "Successfully destroyed holiday conversation."
    redirect_to holiday_conversations_url
  end
end
