class Mediafeed::MediafeedController < ApplicationController
  layout 'mediafeed'
  
  def index
    if current_user && current_user.media?
      @media_requests_by_type = [] #placeholder to make the view work
      render :template => "welcome/mediahome.html"
    else
      @mediafeed_slides = MediafeedSlide.all
      @mediafeed_promos = MediafeedPromo.all
    end
  end

  protected

  def require_media_user
    unless current_user && (current_user.media? || current_user.admin?)
      flash[:message] = "Please log in first"
      redirect_to root_url
    end
  end

end
