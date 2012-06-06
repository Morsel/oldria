class PromotionsController < ApplicationController

  before_filter :find_restaurant
  before_filter :require_manager, :except => [:index]

  def index
    all_promotions = @restaurant.promotions.all(:order => "created_at DESC")
    @promotions = all_promotions.select { |p| p.current? }
    @past_promotions = all_promotions.reject { |p| p.current? }
  end

  def new
    @promotions = @restaurant.promotions.all(:order => "created_at DESC")
    @promotion = Promotion.new(:post_to_twitter_at => Time.now)
  end

  def create
    @promotion = @restaurant.promotions.build(params[:promotion])
    if @promotion.save
      flash[:notice] = "Your promotion has been created"
      redirect_to :action => "new"
    else
      render :action => "edit"
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

  def delete_attachment
    find_promotion
    @promotion.attachment = nil
    @promotion.save
    flash[:notice] = "Deleted attachment"
    redirect_to edit_restaurant_promotion_path(@restaurant, @promotion)
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_promotion
    @promotion = Promotion.find(params[:id])
  end

  def require_manager
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end

end
