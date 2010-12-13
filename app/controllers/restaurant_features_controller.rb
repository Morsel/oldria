class RestaurantFeaturesController < ApplicationController
  before_filter :require_user
  before_filter :authenticate
  before_filter :load_pages, :only => [:index, :bulk_edit]
  before_filter :load_page, :only => [:bulk_edit, :add]

  def index
    redirect_to bulk_edit_restaurant_feature_path(@restaurant, @pages.first)
  end

  def bulk_edit

  end

  def add
    # all feature ids
    all_features_for_page = @page.restaurant_feature_categories.map { |fc| fc.restaurant_features.map(&:id) }.flatten.map(&:to_s)

    new_features = params[:features] || []
    # remove any that aren't in params[:features]
    unchecked_features_for_page = all_features_for_page - new_features

    @restaurant.reset_features(new_features, unchecked_features_for_page)
    redirect_to bulk_edit_restaurant_feature_path(@restaurant, @page)
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
    @page = RestaurantFeaturePage.find(params[:id], :include => {:restaurant_feature_categories => :restaurant_features }) if params[:id]
  end

  def authenticate
    find_restaurant
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end


end