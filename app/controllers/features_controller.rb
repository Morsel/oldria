class FeaturesController < ApplicationController

  before_filter :require_user

  def show
    @feature = RestaurantFeature.find(params[:id])
    @restaurants = current_user.try(:media?) ? @feature.restaurants.subscription_is_active : @feature.restaurants
  end

end