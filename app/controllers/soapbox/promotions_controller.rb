class Soapbox::PromotionsController < ApplicationController

  def index
    if params[:promotion_type_id].present?
      @promotion_type = PromotionType.find(params[:promotion_type_id])
      @promotions = Promotion.current.all(:conditions => { :promotion_type_id => params[:promotion_type_id] })
    else
      @promotions = Promotion.current
    end
  end

end
