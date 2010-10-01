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
    qotd_comments = Admin::Qotd.current.all(:limit => 10, :order => "created_at DESC").
        map(&:admin_conversations).flatten.map(&:comments).flatten
    trend_comments = TrendQuestion.current.all(:limit => 10, :order => "created_at DESC").
        map(&:admin_discussions).flatten.map(&:comments).flatten
    answers = ProfileAnswer.all(:limit => 10, :order => "created_at DESC")
    
    @recent_comments = [qotd_comments, trend_comments, answers].flatten.sort { |a,b| b.created_at <=> a.created_at }[0..9]
  end
end
