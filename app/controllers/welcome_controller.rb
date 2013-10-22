class WelcomeController < ApplicationController
  include RiaCaching

  # preload classes which may be used while caching
  # to prevent "undefined class/module"
  before_filter :preload_classes
  before_filter :require_user, :only => [:refresh, :require_login]

  # cache dashboard for logged in users
  caches_action :index,
                :if =>  Proc.new {|controller| controller.cache? && !controller.params[:is_more] },
                :expires_in => 5.minutes,
                :cache_path => Proc.new { |controller| controller.dashboard_cache_key }

  def initialize
    @per_page = 10
  end

  # GET /welcome/index
  def index
    if current_user
      @announcements = current_user.unread_announcements
      @announcements.each { |announcement| announcement.read_by!(current_user) }
      params[:is_more] ? set_up_dashboard_with_pagination : set_up_dashboard
      render :dashboard , :layout => 'application'
    else
      @testimonials = Testimonial.for_page("Spoonfeed").by_position
      render :layout => 'home'
    end
  end
  
  def require_login
    redirect_to :action => :index
  end

  # GET /welcome/refresh
  # GET /dashboard/refresh
  # refresh cache for dashboard
  def refresh
    expire_action_by_key(dashboard_cache_key)
    @recent_comments = cache_or_get(:load_recent_comments, true)
    @has_more = cache_or_get(:has_more?, true)

    redirect_to :action => :index
  end

  def dashboard_cache_key
    cache_key(controller_name, :index, current_user.id.to_s)
  end

  # check if we need action cache for current action
  def cache?
    case action_name.to_sym
    when :index then current_user && current_user.unread_announcements.blank?
    end
  end

  private

  def set_up_dashboard    
    @recent_comments = cache_or_get(:load_recent_comments)
    #there yet?
    @has_more = cache_or_get(:has_more?)
  end

  def set_up_dashboard_with_pagination
    if current_user.media?
      soapbox_comments   = SoapboxEntry.published.all(:order => "published_at DESC", :conditions => ["created_at > ?", 2.weeks.ago]).map(&:comments)
      answers            = ProfileAnswer.all(:order => "profile_answers.created_at DESC", :conditions => ["profile_answers.created_at > ?", 2.weeks.ago])
      menu_items         = MenuItem.activated_restaurants.all(:order => "menu_items.created_at DESC", :conditions => ["menu_items.created_at > ?", 2.weeks.ago])
      promotions         = Promotion.all(:order => "promotions.created_at DESC", :conditions => ["promotions.created_at > ?", 2.weeks.ago])
      restaurant_answers = RestaurantAnswer.all(:order => "restaurant_answers.created_at DESC", :conditions => ["restaurant_answers.created_at > ?", 2.weeks.ago])   
      a_la_minutes       = ALaMinuteAnswer.all(:order => "a_la_minute_answers.created_at DESC", :conditions => ["a_la_minute_answers.created_at > ?", 2.weeks.ago])         
    else
      soapbox_comments   = SoapboxEntry.published.all(:order => "published_at DESC", :conditions => ["created_at > ?", 2.weeks.ago]).map(&:comments)
      answers            = ProfileAnswer.all(:order => "created_at DESC", :conditions => ["created_at > ?", 2.weeks.ago])
      menu_items         = MenuItem.activated_restaurants.all(:order => "menu_items.created_at DESC", :conditions => ["menu_items.created_at > ?", 2.weeks.ago])
      promotions         = Promotion.all(:order => "created_at DESC", :conditions => ["created_at > ?", 2.weeks.ago])
      restaurant_answers = RestaurantAnswer.all(:order => "created_at DESC", :conditions => ["created_at > ?", 2.weeks.ago])
      a_la_minutes   = []
    end
    all_comments = [soapbox_comments, answers, menu_items, promotions, restaurant_answers,a_la_minutes].flatten.sort { |a,b| b.created_at <=> a.created_at }
    all_comments.slice!(0..(@per_page - 1)) #delete recent

    @recent_comments = all_comments.paginate :page => params[:page], :per_page => @per_page
    @has_pagination = true
  end

  # load recent comments for dashboard
  # this data is common for all users
  def load_recent_comments
    if current_user.media?
      soapbox_comments   = SoapboxEntry.published.all(:limit => @per_page, :order => "published_at DESC").map(&:comments)
      answers            = ProfileAnswer.from_premium_users.all(:limit => @per_page, :order => "created_at DESC")
      menu_items         = MenuItem.activated_restaurants.from_premium_restaurants.all(:limit => @per_page, :order => "menu_items.created_at DESC")
      promotions         = Promotion.from_premium_restaurants.all(:limit => @per_page, :order => "created_at DESC")
      a_la_minutes       = ALaMinuteAnswer.from_premium_responders.all(:limit => @per_page,:order => "a_la_minute_answers.created_at DESC", :conditions => ["a_la_minute_answers.created_at > ?", 2.weeks.ago])         
      restaurant_answers = RestaurantAnswer.activated_restaurants.from_premium_restaurants.all(:limit => @per_page, :order => "restaurant_answers.created_at DESC")
    else
      soapbox_comments   = SoapboxEntry.published.all(:limit => @per_page, :order => "published_at DESC").map(&:comments)
      answers            = ProfileAnswer.all(:limit => @per_page, :order => "created_at DESC")
      menu_items         = MenuItem.activated_restaurants.all(:limit => @per_page, :order => "menu_items.created_at DESC")
      promotions         = Promotion.all(:limit => @per_page, :order => "created_at DESC")
      restaurant_answers = RestaurantAnswer.activated_restaurants.all(:limit => @per_page, :order => "restaurant_answers.created_at DESC")
      a_la_minutes   = []
    end
    [soapbox_comments, answers, menu_items, promotions, restaurant_answers, a_la_minutes].flatten.sort { |a,b| b.created_at <=> a.created_at }[0..(@per_page - 1)]
  end

  def has_more?
    if current_user.media?
      answer_count            = ProfileAnswer.from_premium_users.count(:conditions => ["profile_answers.created_at > ?", 2.weeks.ago])
      menu_item_count         = MenuItem.activated_restaurants.from_premium_restaurants.count(:conditions => ["menu_items.created_at > ?", 2.weeks.ago])
      promotion_count         = Promotion.from_premium_restaurants.count(:conditions => ["promotions.created_at > ?", 2.weeks.ago])
      restaurant_answer_count = RestaurantAnswer.activated_restaurants.from_premium_restaurants.count(:conditions => ["restaurant_answers.created_at > ?", 2.weeks.ago])
    else
      answer_count            = ProfileAnswer.count(:conditions => ["created_at > ?", 2.weeks.ago])
      menu_item_count         = MenuItem.activated_restaurants.count(:conditions => ["menu_items.created_at > ?", 2.weeks.ago])
      promotion_count         = Promotion.count(:conditions => ["created_at > ?", 2.weeks.ago])
      restaurant_answer_count = RestaurantAnswer.activated_restaurants.count(:conditions => ["restaurant_answers.created_at > ?", 2.weeks.ago])
    end
    total_count             = answer_count + menu_item_count + promotion_count + restaurant_answer_count

    total_count > @per_page ||
       (total_count + SoapboxEntry.published.all(:limit => @per_page + 1, :conditions => ["created_at > ?", 2.weeks.ago]).map(&:comments).flatten.size) > @per_page
  end
end
