class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      if @user.media?
        @media_requests_by_type = @user.media_requests.for_dashboard.all(:include => [:subject_matter, :restaurants]).group_by(&:subject_matter)
        render :mediahome
      else
        set_up_dashboard
        render :dashboard
      end
    else
      @page = Page.find_by_slug(slug_for_home_page)
    end
  end

  private

  def slug_for_home_page
    mediafeed? ? 'home_media' : 'home'
  end

  def set_up_dashboard
    find_user_feeds(true)
    @direct_messages = @user.unread_direct_messages.all_not_from_admin(:include => :sender)
    @discussions = current_user.discussions.all(:limit => 5, :order => 'discussions.created_at DESC')
    @discussions_with_new_comments = current_user.discussions.with_comments_unread_by( current_user ).all(:order => 'discussions.created_at DESC') - @discussions
  end
end
