class Restaurants::NewslettersController < ApplicationController

  before_filter :authorize, :except => "show"

  def index
    @restaurant.newsletter_setting || @restaurant.build_newsletter_setting
    unless @restaurant.premium_account?
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
    @newsletter = RestaurantNewsletter.find(params[:id]).first
    @restaurant = @newsletter.restaurant
    @menu_items = @newsletter.menu_items
    @restaurant_answers = @newsletter.restaurant_answers
    @menus = @newsletter.menus
    @promotions = @newsletter.promotions
    @alaminute_answers = @newsletter.a_la_minute_answers
    render :layout => false
  end

  def update
    if @restaurant.update_attributes(params[:restaurant])
      flash[:notice] = "Updated newsletter settings"
      redirect_to :action => "index", :restaurant => @restaurant
     else       
        render :action => "index", :restaurant => @restaurant
    end
  end

  def preview
    if @restaurant.restaurant_newsletters.blank?
      filter_date = 7.day.ago
    else
      filter_date = @restaurant.restaurant_newsletters.find(:all,:order => "id desc").first.created_at
    end

    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC", :limit => 7,:conditions => ["created_at > ? ",filter_date])
    @restaurant_answers = @restaurant.restaurant_answers.all(:order => "created_at DESC", :limit => 7,:conditions => ["created_at > ? ",filter_date])
    @menus = @restaurant.menus.all(:order => "updated_at DESC", :limit => 7,:conditions => ["created_at > ? ",filter_date])
    @promotions = @restaurant.promotions.all(:order => "created_at DESC", :limit => 7,:conditions => ["created_at > ? ",filter_date])
    @alaminute_answers = @restaurant.a_la_minute_answers.all(:order => "created_at DESC", :limit => 7,:conditions => ["created_at > ? ",filter_date])
    render :action => "show", :layout => false
  end

  def approve
    if @restaurant.update_attribute('newsletter_approved', true)
      flash[:notice] = "The newsletter as been approved for delivery."
    else
      flash[:error] = "There was an issue approving the newsletter. Please try again."
    end
    redirect_to :action => "index"
  end

  def disapprove
    if @restaurant.update_attribute('newsletter_approved', false)
      flash[:notice] = "The newsletter as been disapproved for delivery."
    else
      flash[:error] = "There was an issue disapproving the newsletter. Please try again."
    end
    redirect_to :action => "index"
  end  

  def archives    
    unless @restaurant.premium_account?
      render "restaurants/_comming_soon"
     else 
      @status_data = @restaurant.get_campaign 
    end 
  end
    
  def get_campaign_status       
    unless @restaurant.premium_account?
      render "restaurants/_comming_soon"
     else 
      @status_data = @restaurant.get_campaign 
    end    
  end
  
  def get_opened_campaign
    mc = MailchimpConnector.new
    @openeds = mc.client.campaign_opened_AIM({:cid=>params[:campaign_id]})
    render :layout => false
  end

  def get_clicked_campaign
    mc = MailchimpConnector.new
    @clicks = mc.client.campaign_click_detail_AIM({:cid=>params[:campaign_id],:url => restaurant_newsletter_url(@restaurant,@restaurant.restaurant_newsletters.find_by_campaign_id(params[:campaign_id]))})
    render :layout => false
  end

  def get_bounces_campaign
    mc = MailchimpConnector.new
    @bounces = mc.client.campaign_members({:cid=>params[:campaign_id]})
    render :layout => false
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
