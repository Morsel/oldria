class FeaturesController < ApplicationController

  before_filter :require_user

  def show
  	@feature = RestaurantFeature.find(params[:id])
    @keywordable_id =  params[:id]
    @keywordable_type = 'RestaurantFeature'
    @restaurants = current_user.try(:media?) ? @feature.restaurants.subscription_is_active : @feature.restaurants
  end

end