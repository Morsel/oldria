class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      if @user.has_role? :media
        @media_requests = @user.media_requests
        render :mediahome
      else
        @direct_messages = @user.direct_messages.all_not_from_admin(:include => :sender)
        @sent_messages = @user.sent_direct_messages.all(:include => :receiver, :limit => 3)
        @admin_direct_messages = @user.direct_messages.all_from_admin
        @friend_activity = Status.friends_of_user(@user)
        @media_request_conversations = @user.media_request_conversations.all(:include => :media_request, :limit => 5)
        render :dashboard
      end
    else
      # render index.html
    end
  end
end
