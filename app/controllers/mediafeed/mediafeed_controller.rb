class Mediafeed::MediafeedController < ApplicationController
  layout 'mediafeed'
  
  def index
    @mediafeed_slides = MediafeedSlide.all
    @mediafeed_promos = MediafeedPromo.all
  end

end
