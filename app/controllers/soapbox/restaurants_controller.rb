module Soapbox
  class RestaurantsController < ApplicationController
    def show
      @restaurant = Restaurant.find_premium(params[:id])
      if @restaurant.nil?
        redirect_to(soapbox_root_path)
        return
      end
      @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
      @promotions = @restaurant.promotions.recently_posted.all(:limit => 3)
      render :template => 'restaurants/show'
    end
  end
end
