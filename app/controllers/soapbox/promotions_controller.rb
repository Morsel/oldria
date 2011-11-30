class Soapbox::PromotionsController < ApplicationController

  def index
    page = params[:page] || "1"
    if params[:promotion_type_id].present?
      @promotion_type = PromotionType.find(params[:promotion_type_id])
      @promotions = Promotion.from_premium_restaurants.all(:conditions => { :promotion_type_id => params[:promotion_type_id] }, :order => "created_at DESC").paginate(:page => page, :per_page => 10)
    elsif params[:restaurant_id].present?
      @restaurant = Restaurant.find(params[:restaurant_id])
      @promotions = @restaurant.promotions.all(:order => "created_at DESC").paginate(:page => page, :per_page => 10)
    else
      @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC").paginate(:page => page, :per_page => 10)
    end
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

end
