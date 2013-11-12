# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include Facebooker2::Rails::Controller
  # include SslRequirement
  #include ::SslRequirement

  layout :site_layout

  before_filter :notify_emailthing_of_clicked_links
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  helper_method :current_user
  helper_method :current_subscriber
  helper_method :mediafeed?
  helper_method :soapbox?
  helper_method :heatmap

  rescue_from CanCan::AccessDenied do
    if current_user
      flash[:error] = "Sorry: the content you are trying to view is not available to your user account."
      redirect_to root_url
    else
      flash[:notice] = 'Please login.'
      redirect_to login_path
    end
  end

  def get_newsletter_data
    @newsfeed_metropolitan_areas = @digest_metropolitan_areas = @newsfeed_promotions_types = @newsfeed_promotions_types = @newsfeed_regional_areas = @digest_regional_areas = []
    @newsfeed_metropolitan_areas = @user.newsfeed_writer.find_metropolitan_areas_writers(@user) unless @user.newsfeed_writer.blank?
    @digest_metropolitan_areas = @user.digest_writer.find_metropolitan_areas_writers(@user) unless @user.digest_writer.blank?
    

    @newsfeed_regional_areas = @user.newsfeed_writer.find_regional_writers(@user) unless @user.newsfeed_writer.blank?
    @digest_regional_areas = @user.digest_writer.find_regional_writers(@user) unless @user.digest_writer.blank?

    @promotionTypes = PromotionType.find(:all,:order=>"name")

  end
  def update_newsletter_data user_id
      @user = User.find(user_id)     
      @user.metropolitan_areas_writers.map(&:destroy)

      @user.regional_writers.map(&:destroy)         
      @user.newsfeed_writer.update_attributes(params[:newsfeed_writer]) unless @user.newsfeed_writer.blank?
      @user.digest_writer.update_attributes(params[:digest_writer]) unless @user.digest_writer.blank?
      
      @user = User.find(user_id)  #User.find :  For reloading new object! 
      self.get_newsletter_data
      @user.delete_other_writers
  end

  private

  def site_layout
    soapbox? ? 'soapbox' : 'application'
  end

  def mediafeed?
    return @is_mediafeed if defined?(@is_mediafeed)
    @is_mediafeed = params[:controller].match(/mediafeed/) ||
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

  def require_user_or_subscriber
    current_user || current_subscriber
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

  def current_subscriber(create_user_subscriber=false)
    return @current_subscriber if defined?(@current_subscriber)
    @current_subscriber = if current_user
                            create_user_subscriber ? current_user.create_newsletter_subscriber : current_user.newsletter_subscriber
                          elsif cookies.has_key?('newsletter_subscriber_id')
                            NewsletterSubscriber.find(cookies[:newsletter_subscriber_id])
                          end
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
    session[:return_to] = request.url
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
        # resource.build_employment_search(:conditions => params[:search] || {})
        if params[:search].blank?
          EmploymentSearch.new(:conditions => {})
        else
          EmploymentSearch.new(:conditions => params[:search] || {})
        end        
      end
      @search = @employment_search.employments #searchlogic
    else # no resource
      if params[:search].blank?
        @search = Employment
      else
        @search = EmploymentSearch.new(:conditions => params[:search]).employments
      end
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
      extra_params[:employee_profile_james_beard_region_id_equals] = params[:search][:restaurant_james_beard_region_id_equals_any]
    end
    if params[:search].try(:[], :restaurant_metropolitan_area_id_equals_any)
      extra_params[:employee_profile_metropolitan_area_id_equals] = params[:search][:restaurant_metropolitan_area_id_equals_any]
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
  def build_search(resource = nil)
    return false unless resource
    @search = Employment.search(normalized_search_params)

    @employment_search = if resource.employment_search
      resource.employment_search.conditions = @search.conditions
      resource.employment_search
    else
      resource.build_employment_search(:conditions => @search.conditions)
    end
  end

  # Directory (profile) search
  def directory_search_setup
    # Restaurants should be searched too, and the results combined
    extra_params = {}
    if params[:search].has_key?(:profile_cuisines_id_eq_any)
      extra_params[:restaurants_cuisine_id_eq_any] = params[:search][:profile_cuisines_id_eq_any]
    end
    if params[:search].has_key?(:profile_james_beard_region_id_eq_any)
      extra_params[:restaurants_james_beard_region_id_eq_any] = params[:search][:profile_james_beard_region_id_eq_any]
    end
    if params[:search].has_key?(:profile_metropolitan_area_id_eq_any)
      extra_params[:restaurants_metropolitan_area_id_eq_any] = params[:search][:profile_metropolitan_area_id_eq_any]
    end

    users_to_search = soapbox? ? User.in_soapbox_directory : User.in_spoonfeed_directory
    search = users_to_search.search(params[:search])

    if extra_params.present?
      # Restaurant-related search should filter out people w/o matching specialties or roles
      if params[:search].has_key?(:profile_specialties_id_eq_any)
        extra_params[:profile_specialties_id_eq_any] = params[:search][:profile_specialties_id_eq_any]
      end

      extra_search = users_to_search.search(extra_params)
      roles = params[:search][:all_employments_restaurant_role_id_eq_any]
      extra_search_results = extra_search.all(:conditions => ["employments.restaurant_role_id IN (?)", roles])
    end

    @users = [search.all, extra_search_results].flatten.compact.uniq.sort { |a,b|
      a.last_name.downcase <=> b.last_name.downcase
    }
  end

  def is_profile_not_completed? user
     !user.avatar? || user.profile.specialties.blank? || user.profile.cuisines.blank? || user.restaurants.blank?
  end  
  
  def restaurants_has_setup_fb_tw user
      @current_user_session = UserSession.find
      @current_user = user 
      @restaurants_has_not_setup_fb_tw = []
      unless user.restaurants.blank?        
        user.restaurants.each do |restaurant|
          unless restaurant.twitter_authorized? && restaurant.has_facebook_page?
           @restaurants_has_not_setup_fb_tw.push(restaurant) unless (cannot? :edit, restaurant)           
         end
        end  
      end
      
  end 

end
