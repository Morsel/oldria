module Soapbox
  class FeaturePagesController < ApplicationController
    def show
      @restaurant = Restaurant.find(params[:restaurant_id])
      @subject = @page = RestaurantFeaturePage.find(params[:id])
    end
  end
end
