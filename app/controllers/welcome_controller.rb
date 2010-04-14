class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      if @user.has_role?(:media)
        @media_requests_by_type = @user.media_requests.for_dashboard.all(:include => [:conversations_with_comments, :media_request_type, :recipients]).group_by(&:media_request_type)
        render :mediahome
      else
        find_user_feeds(true)
        @direct_messages = @user.unread_direct_messages.all_not_from_admin(:include => :sender)
        render :dashboard
      end
    else
      #redirect_to :controller => 'user_sessions', :action => 'new'
      @page = Page.find_by_slug('home')
    end
  end
end
