module Soapbox
  class RestaurantFeaturesController < ApplicationController
    def show
      @feature = RestaurantFeature.find(params[:id])
      @restaurants = Restaurant.with_feature(@feature)
      render :template => 'restaurant_features/show'
    end
  end
end
