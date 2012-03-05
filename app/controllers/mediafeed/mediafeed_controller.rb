class Mediafeed::MediafeedController < ApplicationController

  before_filter :require_media_user, :only => [:directory, :directory_search]
  
  def index
    redirect_to root_path
  end
  
  def login
    redirect_to login_path
  end
  
  def directory
    @use_search = true
    @users = User.in_soapbox_directory.all(:order => "users.last_name")

    render :template => "directory/index"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results", :locals => { :users => @users }
  end

  protected

  def require_media_user
    unless current_user && (current_user.media? || current_user.admin?)
      flash[:message] = "Please log in with your media account first"
      redirect_to root_url
    end
  end

end
