class Mediafeed::MediafeedController < ApplicationController
  layout 'mediafeed'
  
  def index
    if current_user && current_user.media?
      render :template => "mediafeed/mediafeed/directory"
    else
      @mediafeed_slides = MediafeedSlide.all
      @mediafeed_promos = MediafeedPromo.all
    end
  end
  
  def login
    @user_session = UserSession.new(params[:user_session])
    render :template => 'user_sessions/new'
  end

  protected

  def require_media_user
    unless current_user && (current_user.media? || current_user.admin?)
      flash[:message] = "Please log in first"
      redirect_to root_url
    end
  end

end
