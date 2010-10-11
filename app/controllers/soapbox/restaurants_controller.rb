module Soapbox
  class RestaurantsController < ApplicationController
    def show
      @restaurant = Restaurant.find(params[:id])
      @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
    end
  end
end
