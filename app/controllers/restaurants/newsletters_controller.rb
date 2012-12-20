class Restaurants::NewslettersController < ApplicationController

  before_filter :authorize, :except => "show"

  def index
    unless [56,146].include? params[:restaurant_id].to_i
      render "restaurants/_comming_soon"
    end
  end

  # TODO - remove this once the feature is complete, for testing only
  def create
    @restaurant.send_newsletter_to_subscribers
    newsletter = @restaurant.restaurant_newsletters.last
    redirect_to :action => "show", :id => newsletter.id
  end

  def show
    newsletter = RestaurantNewsletter.find(params[:id])
    @restaurant = newsletter.restaurant
    @menu_items = newsletter.menu_items
    @restaurant_answers = newsletter.restaurant_answers
    @menus = newsletter.menus
    @promotions = newsletter.promotions
    @alaminute_answers = newsletter.a_la_minute_answers
    render :layout => false
  end

  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Updated newsletter settings"
      redirect_to :action => "index", :restaurant => @restaurant
    end
  end

  def preview
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 3)
    @restaurant_answers = @restaurant.restaurant_answers.all(:order => "created_at DESC", :limit => 3)
    @menus = @restaurant.menus.all(:order => "updated_at DESC", :limit => 3)
    @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 3)
    @alaminute_answers = @restaurant.a_la_minute_answers.all(:order => "created_at DESC", :limit => 3)
    render :action => "show", :layout => false
  end

  def approve
    if @restaurant.update_attribute('newsletter_approved', true)
      flash[:notice] = "The newsletter as been approved for delivery."
    else
      flash[:error] = "There was an issue approving the newsletter. Please try again."
    end
    render :action => "index"
  end

  private

  def authorize
    @restaurant = Restaurant.find(params[:restaurant_id])
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end

end
