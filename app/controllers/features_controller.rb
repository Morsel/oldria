class FeaturesController < ApplicationController
  def show
    @feature = RestaurantFeature.find(params[:id])
  end
end