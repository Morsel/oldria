class Hq::HqController < ApplicationController
  layout 'hq'
  
  def index
    @testimonials = Testimonial.for_page("RIA HQ").by_position
  end
end
