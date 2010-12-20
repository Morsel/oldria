class Mediafeed::MediafeedController < ApplicationController
  layout 'mediafeed'
  
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
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_soapbox_directory.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
    else
      directory_search_setup
      @use_search = true
    end

    render :template => "directory/index"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results"
  end

  protected

  def require_media_user
    unless current_user && (current_user.media? || current_user.admin?)
      flash[:message] = "Please log in first"
      redirect_to root_url
    end
  end

end
