class PromotionsController < ApplicationController

  before_filter :find_restaurant

  def new
    @promotions = @restaurant.promotions

    @promotion = Promotion.new
  end

  def create
    @promotion = @restaurant.promotions.build(params[:promotion])
    if @promotion.save
      flash[:notice] = "Your promotion has been created"
      redirect_to :action => "new"
    else
      @promotions = @restaurant.promotions
      render :action => "new"
    end
  end

  def edit
    find_promotion
  end

  def update
    find_promotion
    if @promotion.update_attributes(params[:promotion])
      flash[:notice] = "Your promotion has been updated"
      redirect_to :action => "new"
    else
      render :action => "edit"
    end
  end

  def destroy
    find_promotion
    flash[:notice] = "Deleted #{@promotion.title}"
    @promotion.destroy
    redirect_to new_restaurant_promotion_path(@restaurant)
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_promotion
    @promotion = Promotion.find(params[:id])
  end

end
