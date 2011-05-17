class PromotionsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @promotion = Promotion.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @promotion = @restaurant.promotions.build(params[:promotion])
    if @promotion.save
      flash[:notice] = "Your promotion has been saved"
      redirect_to :action => "new"
    else
      render :action => "new"
    end
  end

end
