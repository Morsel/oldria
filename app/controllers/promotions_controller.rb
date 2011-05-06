class PromotionsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @promotion = Promotion.new
  end

  def create
    flash[:notice] = "Your promotion has been saved"
    redirect_to :action => "new"
  end

end
