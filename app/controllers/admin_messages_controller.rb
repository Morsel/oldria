class AdminMessagesController < ApplicationController
  def show
    @admin_message = Admin::Message.find(params[:id])
  end
end
