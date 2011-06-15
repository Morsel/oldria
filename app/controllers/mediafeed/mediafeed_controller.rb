class Mediafeed::MediafeedController < ApplicationController
  layout 'mediafeed'
  before_filter :require_media_user, :only => [:directory, :directory_search]
  
  def index
    @mediafeed_home_page = true
    if current_user && current_user.media?
      redirect_to mediafeed_directory_path
    else
      @mediafeed_slides = MediafeedSlide.all
      @mediafeed_promos = MediafeedPromo.all
    end
  end
  
  def login
    @user_session = UserSession.new(params[:user_session])
    render :template => 'user_sessions/new'
  end
  
  def directory
    directory_search_setup
    @use_search = true

    render :template => "directory/index"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results"
  end

  protected

  def require_media_user
    unless current_user && (current_user.media? || current_user.admin?)
      flash[:message] = "Please log in with your media account first"
      redirect_to root_url
    end
  end

end
