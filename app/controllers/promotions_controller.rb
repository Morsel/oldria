class PromotionsController < ApplicationController
  before_filter :require_user, :only =>[:details]
  before_filter :find_restaurant
  before_filter :require_manager, :except => [:index,:details,:preview]
  before_filter :social_redirect, :only => [:edit]

  def index
    all_promotions = @restaurant.promotions.all(:order => "created_at DESC")
    @promotions = all_promotions.select { |p| p.current? }
    @past_promotions = all_promotions.reject { |p| p.current? }
  end

  def new
    @promotions = @restaurant.promotions.all(:order => "created_at DESC")
    @promotion = Promotion.new(:post_to_twitter_at => Time.now, :post_to_facebook_at => Time.now)
    @promotion.start_date = Time.now
    build_social_posts
  end

  def create
    @promotion = @restaurant.promotions.build(params[:promotion])    
    if @promotion.save
       @promotion.notify_newsfeed_request!       
      flash[:notice] = "Your promotion has been created"
      redirect_to :action => "new"
    else
      flash[:error] = "Your promotion could not be saved. Please review the errors below."
      build_social_posts
      render :action => "edit"
    end
  end

  def edit
    find_promotion
    build_social_posts
  end

  def update
    find_promotion
    if @promotion.update_attributes(params[:promotion])
      flash[:notice] = "Your promotion has been updated"
      redirect_to_social_or 'new'
    else
      flash[:error] = "Your promotion could not be saved. Please review the errors below."
      build_social_posts
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

  def facebook_post
    @promotions = @restaurant.promotions.find(params[:id])
    social_post = SocialPost.find(params[:social_id])
    if @promotions.post_to_facebook(social_post.message)
      flash[:notice] = "Posted #{social_post.message} to Facebook page"
    else
      flash[:error] = "Not able to post #{social_post.message} to Facebook page"
    end  
    redirect_to restaurant_social_posts_path(@restaurant)
  end


  def details    
    @promotion = Promotion.find(params[:id]) 
    @restaurant = @promotion.restaurant
    if current_user.media?
      UserRestaurantVisitor.profile_visitor(current_user,@restaurant.id)
    end     
  end  

  def preview
    @promotion = Promotion.find(params[:id])
    @restaurant = @promotion.restaurant
    render :layout =>false    
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

  def social_redirect
    if params[:social]
      session[:redirect_to_social_posts] = restaurant_social_posts_page_path(@restaurant, 'newsfeed')
    end
  end

  def redirect_to_social_or(action)
    redirect_to (session[:redirect_to_social_posts].present?) ? session.delete(:redirect_to_social_posts) : { :action => action }
  end

  def build_social_posts
    (TwitterPost::POST_LIMIT - @promotion.twitter_posts.size).times { @promotion.twitter_posts.build }
    (FacebookPost::POST_LIMIT - @promotion.facebook_posts.size).times { @promotion.facebook_posts.build }
  end

end
