class Soapbox::PromotionsController < ApplicationController

  def index
    if params[:promotion_type_id].present?
      @promotion_type = PromotionType.find(params[:promotion_type_id])
      @promotions = Promotion.from_premium_restaurants.current.all(:conditions => { :promotion_type_id => params[:promotion_type_id] })
    else
      @promotions = Promotion.from_premium_restaurants.current
    end
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

end
