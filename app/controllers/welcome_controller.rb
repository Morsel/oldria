class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      if @user.has_role? :media
        render :mediahome
      else
        @direct_messages = @user.direct_messages.all_not_from_admin(:joins => :sender)
        @sent_messages = @user.sent_direct_messages.all(:joins => :receiver)
        @admin_direct_messages = @user.direct_messages.all_from_admin
        @friend_activity = Status.friends_of_user(@user)
        render :dashboard
      end
    else
      # render index.html
    end
  end
end
