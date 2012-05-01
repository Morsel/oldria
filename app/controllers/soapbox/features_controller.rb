class Soapbox::FeaturesController < ApplicationController
  
  def show
    @feature = RestaurantFeature.find(params[:id])
    @restaurants = @feature.restaurants
    render :template => 'features/show'
  end

end
