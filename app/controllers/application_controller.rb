# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include Facebooker2::Rails::Controller

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :preload_resources

  helper_method :current_user
  helper_method :mediafeed?

  rescue_from CanCan::AccessDenied do
    if current_user
      flash[:error] = "Sorry: the content you are trying to view is not available to your user account."
      redirect_to root_url
    else
      flash[:notice] = 'Please login.'
      redirect_to login_path
    end
  end

  private

  def mediafeed?
    return @is_mediafeed if defined?(@is_mediafeed)
    @is_mediafeed = (current_subdomain =~ /^mediafeed/) || (current_user && current_user.media?)
  end

  def find_user_feeds(dashboard = false)
    @feeds = current_user.chosen_feeds(dashboard) || Feed.featured.all(:limit => (dashboard ? 2 : nil))
    @user_feed_ids = @feeds.map(&:id)
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_twitter_authorization
    unless current_user.twitter_authorized?
      flash[:notice] = "You must be authorized with Twitter to view this page"
      redirect_to new_twitter_authorization_path
      return false
    end
  end

  def require_account_manager_authorization
    return true if current_user.admin?
    @restaurant = Restaurant.find(params[:restaurant_id])
    employment = current_user.reload.employments.find(:first, 
        :conditions => {:restaurant_id => @restaurant.id})
    omniscient = employment && employment.omniscient?
    unless omniscient
      flash[:error] = "You don't have permission to access that page"
      redirect_to root_path
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
    true
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default = root_url)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def require_admin
    return false if !require_user
    unless current_user.admin?
      flash[:error] = "Oops, you don't have access to the admin area. Nothing exciting there anyways."
      redirect_to root_url
      return false
    end
  end

  def activerecord_error_list(errors = nil)
    return '' unless errors.instance_of? ActiveRecord::Errors
    error_list = '<ul class="error_list">'
    error_list << errors.collect do |e, m|
      "<li>#{e.humanize unless e == "base"} #{m}</li>"
    end.to_s << '</ul>'
    error_list
  end

  def preload_resources
    load_random_coached_update
    load_current_user_statuses
  end

  def load_random_coached_update
    return unless current_user && !current_user.media?
    @coached_message = CoachedStatusUpdate.current.random.first
  end

  def load_current_user_statuses
    return unless current_user && !current_user.media?
    @current_user_recent_statuses = current_user.statuses.all(:limit => 2)
  end

  def archived_view?
    return @archived_view if defined?(@archived_view)
    @archived_view = params[:view_all] ? true : false
  end
  helper_method :archived_view?

  def get_message_counts
    @ria_message_count = current_user.try(:ria_message_count)
    @private_message_count = current_user.try(:unread_direct_messages).try(:size)
    @discussions_count = current_user && (current_user.unread_discussions + current_user.discussions.with_comments_unread_by(current_user)).uniq.size
    @media_requests_count = current_user.try(:viewable_media_request_discussions).try(:size)
  end

  def load_past_features
    @qotds ||= SoapboxEntry.qotd.published.recent.all(:include => :featured_item).map(&:featured_item)
    @trend_questions ||= SoapboxEntry.trend_question.published.recent.all(:include => :featured_item).map(&:featured_item)
  end
  
  ##
  # Employment saved-search methods
  def search_setup(resource = nil, options = {})
    if resource
      @employment_search = if resource.employment_search
        resource.employment_search
      else
        resource.build_employment_search(:conditions => params[:search] || {})
      end
      @search = @employment_search.employments #searchlogic
    else # no resource
      @search = EmploymentSearch.new(:conditions => params[:search]).employments
    end

    options.reverse_merge!(:include => [:restaurant, :employee], :order => "restaurants.name")
    @solo_users, @restaurants_and_employments = @search.all(options).partition { |e| e.restaurant.nil? }
    @restaurants_and_employments = @restaurants_and_employments.group_by(&:restaurant)
  end

  def save_search
    if params[:search] && defined?(@employment_search)
      @employment_search.conditions = normalized_search_params
      return @employment_search.save
    end
    false
  end

  def normalized_search_params
    normalized = params[:search].reject{ |k,v| v.blank? }
    normalized.blank? ? {:id => ""} : normalized
  end
  
  # For use when building the search on a Trend Question or other message
  def build_search(resource = nil, soapbox_only = false)
    return false unless resource
    @search = Employment.search(normalized_search_params)
    @search.post_to_soapbox = true if soapbox_only

    @employment_search = if resource.employment_search
      resource.employment_search.conditions = @search.conditions
      resource.employment_search
    else
      resource.build_employment_search(:conditions => @search.conditions)
    end
  end

  def directory_search_setup
    @search = User.search(params[:search])
    if params[:controller].match(/soapbox/)
      @users = @search.all(:order => "users.last_name", :conditions => { :premium_account => true }).uniq
    else
      @users = @search.all(:order => "users.last_name").uniq
    end      
  end
  
end
