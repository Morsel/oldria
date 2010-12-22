class WelcomeController < ApplicationController
  
  def index
    if current_user
      @per_page = 10
      @user = current_user
      @announcements   = current_user.unread_announcements.each { |announcement| announcement.read_by!(current_user) }
      params[:is_more] ? set_up_dashboard_with_pagination : set_up_dashboard
      render :dashboard
    else
      @sf_slides = SfSlide.all(:limit => 4)
      @sf_promos = SfPromo.all(:limit => 4)
      render :layout => 'home'
    end
  end

  private

  def slug_for_home_page
    mediafeed? ? 'home_media' : 'home'
  end

  def set_up_dashboard
    soapbox_comments = SoapboxEntry.published.all(:limit => @per_page, :order => "published_at DESC").map(&:comments)
    answers = ProfileAnswer.all(:limit => @per_page, :order => "created_at DESC")

    #there yet?
    @has_more = has_more?

    all_comments = [soapbox_comments, answers].flatten.sort { |a, b| b.created_at <=> a.created_at }

    @recent_comments = all_comments[0..(@per_page - 1)]

  end

  def set_up_dashboard_with_pagination
    soapbox_comments = SoapboxEntry.published.all(:order => "published_at DESC",
                                                  :conditions => ["created_at > ?", 2.weeks.ago]).map(&:comments)
    answers = ProfileAnswer.all(:order => "created_at DESC",
                                :conditions => ["created_at > ?", 2.weeks.ago])

    all_comments = [soapbox_comments, answers].flatten.sort { |a,b| b.created_at <=> a.created_at }
    
    all_comments.slice!(0..(@per_page - 1)) #delete recent
    
    @recent_comments = all_comments.paginate :page => params[:page], :per_page => @per_page
    @has_pagination = true
  end

  def has_more?
    recent_answers = ProfileAnswer.count(:conditions => ["created_at > ?", 2.weeks.ago])
    recent_answers > @per_page ||
       recent_answers + SoapboxEntry.published.all(:limit => @per_page + 1,
                                  :conditions => ["created_at > ?", 2.weeks.ago]).map(&:comments).flatten.size > @per_page
  end

end
