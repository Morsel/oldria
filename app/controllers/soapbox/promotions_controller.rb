class Soapbox::PromotionsController < ApplicationController

  def index
    # FIXME needs refactoring
    if params[:promotion_type_id].present?
      @promotion_type = PromotionType.find(params[:promotion_type_id])
      if params[:view_all] == "true"
        @promotions = Promotion.from_premium_restaurants.all(:conditions => { :promotion_type_id => params[:promotion_type_id] },
                                                             :order => "created_at DESC")
      else
        @promotions = Promotion.from_premium_restaurants.current.all(:conditions => { :promotion_type_id => params[:promotion_type_id] },
                                                                     :order => "created_at DESC")
      end
    elsif params[:restaurant_id].present?
      @restaurant = Restaurant.find(params[:restaurant_id])
      if params[:view_all] == "true"
        @promotions = @restaurant.promotions.all(:order => "created_at DESC")
      else
        @promotions = @restaurant.promotions.current.all(:order => "created_at DESC")
      end
    else
      if params[:view_all] == "true"
        @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC")
      else
        @promotions = Promotion.from_premium_restaurants.current.all(:order => "created_at DESC")        
      end
    end
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

end
