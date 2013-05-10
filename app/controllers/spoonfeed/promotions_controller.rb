class Spoonfeed::PromotionsController < ApplicationController

  before_filter :require_user

  def index
    @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

  def show
    @promotion = Promotion.find(params[:id]) 
    @restaurant = @promotion.restaurant   
  end

end
