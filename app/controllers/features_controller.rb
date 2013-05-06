class FeaturesController < ApplicationController

  before_filter :require_user

  def show
  	@feature = RestaurantFeature.find(params[:id])
    if current_user.media?
      @trace_keyword =  TraceKeyword.find_by_keywordable_id_and_keywordable_type_and_user_id(params[:id], "RestaurantFeature",current_user.id)
      @trace_keyword.nil? ? @feature.trace_keywords.create(:user_id=>current_user.id,:count =>1) : @trace_keyword.increment!(:count) 
    end  
    @restaurants = current_user.try(:media?) ? @feature.restaurants.subscription_is_active : @feature.restaurants
  end


end