module Soapbox
  class FeaturePagesController < ApplicationController
    def show
      @restaurant = Restaurant.find(params[:restaurant_id])
      @subject = @page = RestaurantFeaturePage.find(params[:id])
      render :template => 'feature_pages/show'
    end
  end
end
