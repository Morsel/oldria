class WelcomeController < ApplicationController
 
  # cache dashboard for logged in users 
  caches_action :index,
                :if =>  Proc.new {|controller| controller.cache? }, 
                :expires_in => 5.minutes,
                :cache_path => Proc.new { |controller| controller.cache_key }
  def index
    if current_user
      @user = current_user
      set_up_dashboard
      render :dashboard
    else
      @sf_slides = SfSlide.all(:limit => 4)
      @sf_promos = SfPromo.all(:limit => 4)
      render :layout => 'home'
    end
  end

  def cache?
    case action_name
    when :index then current_user && current_user.unread_announcements.blank?
    end
  end

  # generate cache key for logged in users
  def cache_key
    current_user ? "#{controller_name}_#{action_name}_#{current_user.id.to_s}" : nil
  end

  private

  def slug_for_home_page
    mediafeed? ? 'home_media' : 'home'
  end

  def set_up_dashboard
    soapbox_comments = SoapboxEntry.published.all(:limit => 10, :order => "published_at DESC").map(&:comments)
    answers = ProfileAnswer.all(:limit => 10, :order => "created_at DESC")
 
    @announcements   = current_user.unread_announcements.each { |announcement| announcement.read_by!(current_user) } 
    @recent_comments = [soapbox_comments, answers].flatten.sort { |a,b| b.created_at <=> a.created_at }[0..9]
  end
end
