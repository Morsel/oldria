class HolidayConversationsController < ApplicationController
  before_filter :require_user

  def show
    load_and_authorize_holiday_conversation
    @comments = @holiday_conversation.comments.all(:include => :user).reject(&:new_record?)
    build_comment
  end

  def update
    require_admin
    load_and_authorize_holiday_conversation
    @holiday_conversation.update_attributes(params[:holiday_conversation])
    redirect_to admin_holiday_path(@holiday_conversation.holiday)
  end

  private

  def build_comment
    @comment = @holiday_conversation.comments.build(:user => current_user)
    @comment.attachments.build
    @comment_resource = [@holiday_conversation, @comment]
  end

  def load_and_authorize_holiday_conversation
    @holiday_conversation = HolidayConversation.find(params[:id])
    # unauthorized! if cannot? :read, @holiday_conversation
  end

end
