# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include Facebooker2::Rails::Controller
  include SslRequirement

  layout :site_layout

  before_filter :notify_emailthing_of_clicked_links

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper_method :current_user
  helper_method :mediafeed?
  helper_method :soapbox?

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

  def site_layout
    soapbox? ? 'soapbox' : 'application'
  end

  def mediafeed?
    return @is_mediafeed if defined?(@is_mediafeed)
    @is_mediafeed = (current_subdomain =~ /^mediafeed/) || 
        params[:controller].match(/mediafeed/) || 
        (current_user && current_user.media?) || 
        request.path.match(/mediafeed/)
  end
  
  def soapbox?
    return @is_soapbox if defined?(@is_soapbox)
    @is_soapbox = (current_subdomain =~ /^soapbox/) || 
        params[:controller].match(/soapbox/) || 
        request.path.match(/soapbox/)
  end

  def require_user_unless_soapbox
    soapbox? ? true : require_user
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
    if cannot? :manage, @restaurant
      flash[:error] = "You are not permitted to access this page"
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
      flash[:error] = "Oops, you don't have access to the admin area. Nothing exciting there anyway."
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

### Content for layout
  def past_featured_qotds
    @featured_qotds ||= SoapboxEntry.qotd.published.recent.all(:include => :featured_item).map(&:featured_item)
  end
  helper_method :past_featured_qotds

  def past_featured_trends
    @featured_trend_questions ||= SoapboxEntry.trend_question.published.recent.all(:include => :featured_item).map(&:featured_item)
  end
  helper_method :past_featured_trends

  def load_past_features
    past_featured_qotds
    past_featured_trends
  end

  def past_qotds
    @qotds ||= Admin::Qotd.current.all(:order => "created_at DESC", :limit => 10)
  end
  helper_method :past_qotds

  def past_trends
    @trend_questions ||= TrendQuestion.current.all(:order => "created_at DESC", :limit => 10)
  end
  helper_method :past_trends

  def load_random_btl_question
    return unless current_user && current_user.btl_enabled?
    return if params[:controller].match(/soapbox/)
    return if params[:controller].match(/admin/)
    return if ["create", "update", "destroy"].include? params[:action]
    @btl_question = ProfileQuestion.for_subject(current_user).all({:order => RANDOM_SQL_STRING}).reject { |q| q.answered_by?(current_user) }.first
  end

### Messaging helpers
  def archived_view?
    return @archived_view if defined?(@archived_view)
    @archived_view = params[:view_all] ? true : false
  end
  helper_method :archived_view?

  def get_message_counts
    @ria_message_count = current_user.try(:ria_message_count)
    @private_message_count = current_user.try(:unread_direct_messages).try(:size)
    @discussions_count = current_user && (current_user.unread_discussions + current_user.discussions.with_comments_unread_by(current_user)).uniq.size
    @media_requests_count = current_user.try(:viewable_unread_media_request_discussions).try(:size)
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

    extra_params = build_extra_profile_params
    solo_search = EmploymentSearch.new(:conditions => extra_params).solo_employments if extra_params.present?

    options.reverse_merge!(:include => [:restaurant, :employee], :order => "restaurants.name")

    @solo_users, @restaurants_and_employments = @search.all(options).partition { |e| e.restaurant.nil? }
    @restaurants_and_employments = @restaurants_and_employments.group_by(&:restaurant)

    # FIXME - should call solo_search.all(options) but it generates a DB error
    # instead since we only use the options in media requests we'll manually filter
    @solo_users = [@solo_users, solo_search].flatten.compact.uniq if extra_params.present?
    @solo_users = @solo_users.select { |u| u.employee.mediafeed_visible } if mediafeed?
  end

  def build_extra_profile_params
    extra_params = {}
    if params[:search].try(:[], :restaurant_james_beard_region_id_equals_any)
      extra_params[:employee_profile_james_beard_region_id_eq_any] = params[:search][:restaurant_james_beard_region_id_equals_any]
    end
    if params[:search].try(:[], :restaurant_metropolitan_area_id_equals_any)
      extra_params[:employee_profile_metropolitan_area_id_eq_any] = params[:search][:restaurant_metropolitan_area_id_equals_any]
    end

    return extra_params
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

  # Directory (profile) search
  def directory_search_setup
    # We want to repeat some of the searches through the users' restaurants
    extra_params = {}
    if params[:search].try(:[], :profile_cuisines_id_eq_any)
      extra_params[:restaurants_cuisine_id_eq_any] = params[:search][:profile_cuisines_id_eq_any]
    end
    if params[:search].try(:[], :profile_james_beard_region_id_eq_any)
      extra_params[:restaurants_james_beard_region_id_eq_any] = params[:search][:profile_james_beard_region_id_eq_any]
    end
    if params[:search].try(:[], :profile_metropolitan_area_id_eq_any)
      extra_params[:restaurants_metropolitan_area_id_eq_any] = params[:search][:profile_metropolitan_area_id_eq_any]
    end
    if params[:search].try(:[], :employments_restaurant_name_eq_any)
      extra_params[:default_employment_solo_restaurant_name_eq_any] = params[:search][:employments_restaurant_name_eq_any]
    end

    if soapbox?
      search = User.in_soapbox_directory.search(params[:search]).all
      extra_search_results = User.in_soapbox_directory.search(extra_params).all if extra_params.present?
      @users = [search, extra_search_results].flatten.compact.uniq.sort { |a,b| a.last_name.downcase <=> b.last_name.downcase }
    else
      search = User.in_spoonfeed_directory.search(params[:search]).all
      extra_search_results = User.in_spoonfeed_directory.search(extra_params).all if extra_params.present?

      @users = [search, extra_search_results].flatten.compact.uniq.sort { |a,b| a.last_name.downcase <=> b.last_name.downcase }
    end
  end
  
end
