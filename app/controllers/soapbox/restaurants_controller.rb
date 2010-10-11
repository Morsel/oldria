module Soapbox
  class RestaurantsController < ApplicationController
    def show
      @restaurant = Restaurant.find_premium(params[:id])
      if @restaurant.nil?
        redirect_to(soapbox_index_path)
        return
      end
      @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
    end
  end
end
