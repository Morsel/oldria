class RestaurantFeaturesController < ApplicationController
  before_filter :require_user
  before_filter :authenticate
  before_filter :load_pages

  def index

  end

  def create
    @restaurant.reset_features(params[:features])
    render :action => :index  
  end

  private

  def load_pages
    @pages = RestaurantFeaturePage.by_name.all(
        :include => {:restaurant_feature_categories => :restaurant_features})
  end

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id],
        :include => {:restaurant_features => :restaurant_feature_category})
  end

  def authenticate
    find_restaurant
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end


end