class RestaurantFeaturesController < ApplicationController
  before_filter :require_user
  before_filter :authenticate
  before_filter :load_pages
  before_filter :load_page

  def index

  end

  def create
    # all feature ids
    all_features_for_page = @page.restaurant_feature_categories.map { |fc| fc.restaurant_features.map(&:id) }.flatten.map(&:to_s)

    # remove any that aren't in params[:features]
    unchecked_features_for_page = all_features_for_page - params[:features]

    @restaurant.reset_features(params[:features], unchecked_features_for_page)
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

  def load_page
    @page = if params[:page_id]
            then RestaurantFeaturePage.find(params[:page_id], :include => {:restaurant_feature_categories => :restaurant_features })
            else @pages.first
            end
  end

  def authenticate
    find_restaurant
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end


end