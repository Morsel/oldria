class WelcomeController < ApplicationController
  # preload classes which may be used while caching
  # to prevent "undefined class/module"
  before_filter :preload_classes

  # cache dashboard for logged in users 
  caches_action :index,
                :if =>  Proc.new {|controller| controller.cache? }, 
                :expires_in => 5.minutes,
                :cache_path => Proc.new { |controller| controller.cache_key }
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

  # check if we need action cache for current action
  def cache?
    case action_name.to_sym
    when :index then current_user && current_user.unread_announcements.blank?
    end
  end

  # generate cache key for logged in users
  # ex "welcome_index_205"
  def cache_key
    current_user ? "#{controller_name}_#{action_name}_#{current_user.id.to_s}" : nil
  end

  # recent comments cache key 
  # common for all users
  def comments_cache_key
    "#{controller_name}_#{action_name}_comments"
  end

  private

  def slug_for_home_page
    mediafeed? ? 'home_media' : 'home'
  end

  def set_up_dashboard
    @recent_comments = load_recent_comments
    #there yet?
    @has_more = has_more?
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
  
   # load recent comments for dashboard
  # this data is common for all users
  def load_recent_comments
    if Rails.cache.exist?(comments_cache_key) && self.perform_caching
      Rails.cache.read comments_cache_key
    else
      soapbox_comments = SoapboxEntry.published.all(:limit => @per_page, :order => "published_at DESC").map(&:comments)
      answers = ProfileAnswer.all(:limit => @per_page, :order => "created_at DESC") 
      recent_comments = [soapbox_comments, answers].flatten.sort { |a,b| b.created_at <=> a.created_at }[0..(@per_page - 1)]
      Rails.cache.write(comments_cache_key, recent_comments, :expires_in => 5.minutes)
      recent_comments
    end
  end
  
  def has_more?
    recent_answers = ProfileAnswer.count(:conditions => ["created_at > ?", 2.weeks.ago])
    recent_answers > @per_page ||
       recent_answers + SoapboxEntry.published.all(:limit => @per_page + 1,
                                  :conditions => ["created_at > ?", 2.weeks.ago]).map(&:comments).flatten.size > @per_page
  end
  
   def preload_classes
    ProfileAnswer
   end
end
