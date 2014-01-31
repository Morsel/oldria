class FeaturesController < ApplicationController

  before_filter :require_user

  def show
  	@feature = RestaurantFeature.find(params[:id])
    @keywordable_id =  params[:id]
    @keywordable_type = 'RestaurantFeature'
    @restaurants = current_user.try(:media?) ? @feature.restaurants.subscription_is_active : @feature.restaurants
  end

  def index
  	respond_to do |format|
      #format.html
      format.js { auto_complete_featureskeywords }
    end
  end

  def auto_complete_featureskeywords
    feature_keyword_name = params[:term]
    @feature_keywords = RestaurantFeature.find(:all,:conditions => ["value like ?", "%#{feature_keyword_name}%"],:limit => 15)
    if @feature_keywords.present?
      render :json => @feature_keywords.map(&:value)
    else
      render :json => @feature_keywords.push('This feature does not yet exist in our database. Please try another feature name.')
    end
  end  

end