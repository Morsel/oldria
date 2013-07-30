class Restaurants::SocialPostController < ApplicationController

  before_filter :require_user
  before_filter :authorize
  before_filter :check_employments, :only => [:index]

  def index
    @social_posts = SocialPost.pending.map{|social_post| social_post if (can? :edit, social_post.source.send(:restaurant)) }.compact
  end

  def newsfeed
    @promotions = Promotion.social_posts(@restaurant.id)
  end

  def menu_items
    @menu_items = MenuItem.social_posts(@restaurant.id)
  end

  protected

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def load_page
    @page = params[:page]
    if @page && self.respond_to?(@page)
      self.send @page
    else
      redirect_to restaurant_social_posts_page_path(@restaurant, 'newsfeed')
    end
  end

  def authorize
    find_restaurant
    if (cannot? :edit, @restaurant) || (cannot? :update, @restaurant)
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant and return
    end
    # load_page
  end

end
