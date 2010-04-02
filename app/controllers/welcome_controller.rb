class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      if @user.has_role?(:media)
        @media_requests_by_type = @user.media_requests.for_dashboard.all(:include => [:conversations_with_comments, :media_request_type, :recipients]).group_by(&:media_request_type)
        render :mediahome
      else
        find_user_feeds(true)
        @direct_messages = @user.direct_messages.all_not_from_admin(:include => :sender)
        render :dashboard
      end
    else
      @page = Page.find_by_slug('welcome_new_user')
    end
  end
end
