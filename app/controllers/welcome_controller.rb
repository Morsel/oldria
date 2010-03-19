class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      if @user.has_role?(:media)
        @media_requests_by_type = @user.media_requests.for_dashboard.all(:include => [:conversations_with_comments, :media_request_type, :recipients]).group_by(&:media_request_type)
        render :mediahome
      else
        find_user_feeds
        @direct_messages = @user.direct_messages.all_not_from_admin(:include => :sender)
        @admin_direct_messages = @user.direct_messages.all_from_admin
        @friend_activity = Status.friends_of_user(@user).all(:limit => 10)
        @media_request_conversations = @user.media_request_conversations.all(:include => :media_request, :limit => 5, :order => "media_requests.created_at DESC", :conditions => {:media_requests => {:status => 'approved'}})
        render :dashboard
      end
    else
      @page = Page.find_by_slug('welcome_new_user')
    end
  end
end
