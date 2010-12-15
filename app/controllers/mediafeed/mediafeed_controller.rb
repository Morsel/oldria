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

end
