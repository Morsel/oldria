# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #before_filter :authenticate
  before_filter :find_coached_message
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper_method :current_user

  rescue_from CanCan::AccessDenied do
    if current_user
      flash[:error] = "Access denied. This area is above your pay grade."
      redirect_to root_url
    else
      flash[:notice] = 'Access denied. Try to log in first.'
      redirect_to login_path
    end
  end

  private
  
  def find_coached_message
    @coached_message = CoachedStatusUpdate.current.random.first
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
      flash[:error] = "This is an administrative area. Nothing exciting here at all."
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

  protected

  def authenticate
    if RAILS_ENV == 'production'
      authenticate_or_request_with_http_basic do |username, password|
        username == "spoon" && password == "feed"
      end
    end
  end
end
