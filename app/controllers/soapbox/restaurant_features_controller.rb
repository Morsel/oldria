module Soapbox
  class RestaurantFeaturesController < ApplicationController
    def show
      @feature = RestaurantFeature.find(params[:id])
      @restaurants = Restaurant.with_feature(@feature)
    end
  end
end
