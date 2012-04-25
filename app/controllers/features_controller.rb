class FeaturesController < ApplicationController
  def show
    @feature = RestaurantFeature.find(params[:id])
    @restaurants = current_user.media? ? @feature.restaurants.subscription_is_active : @feature.restaurants
  end
end