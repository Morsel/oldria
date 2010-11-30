class Hq::HqController < ApplicationController
  layout 'hq'
  
  def index
    @hq_slides = HqSlide.all
    @hq_promos = HqPromo.all
  end
end
