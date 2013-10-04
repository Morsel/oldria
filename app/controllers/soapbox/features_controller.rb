class Soapbox::FeaturesController < ApplicationController
  
  def show
    @feature = RestaurantFeature.find(params[:id])
    @restaurants = @feature.restaurants.from_premium_restaurants #get only premium restaurants
    render :template => 'features/show'
  end

end
