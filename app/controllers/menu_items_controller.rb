class MenuItemsController < ApplicationController

  before_filter :require_user
  before_filter :require_manager, :except => [:index,:get_keywords,:add_keywords]

  def index
    find_restaurant
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    render :template => "soapbox/menu_items/index" if cannot?(:edit, @restaurant)
  end

  def new
    @is_new = true
    @menu_item = MenuItem.new(:post_to_twitter_at => Time.now, :post_to_facebook_at => Time.now)
    @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
  end

  def create
    debugger
    @menu_item = @restaurant.menu_items.build(params[:menu_item])
    if @menu_item.save
      flash[:notice] = "Your menu item has been saved"
      redirect_to :action => "index"
    else
      @is_new = true
      @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
      @categories_keywords = OtmKeyword.find(:all,:conditions=>["name like ? ","%#{params[:menu_item][:search_keywords]}%"],:order => "category ASC, name ASC",:limit=>100) 
      render :action => "new"
    end
  end

  def edit
    @menu_item = @restaurant.menu_items.find(params[:id])
    @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
  end

  def update
    @menu_item = @restaurant.menu_items.find(params[:id])
    if @menu_item.update_attributes(params[:menu_item])
      flash[:notice] = "Your menu item has been saved"
      redirect_to :action => "index"
    else
      @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
      render :action => "edit"
    end
  end

  def destroy
    @menu_item = @restaurant.menu_items.find(params[:id])
    if @menu_item.destroy
      flash[:notice] = "Your menu item has been deleted"
      redirect_to :action => "index"
    end
  end

  def facebook_post
    @menu_item = @restaurant.menu_items.find(params[:id])
    @menu_item.queue_for_facebook_page
    flash[:notice] = "Posted #{@menu_item.name} to Facebook page"
    redirect_to :action => "index"
  end

  def get_keywords
    find_restaurant
    @categories_keywords = OtmKeyword.find(:all,:conditions=>["name like ? ","%#{params[:search_keywords]}%"],:order => "category ASC, name ASC",:limit=>100) 
     respond_to do |wants|      
        wants.html { render :partial=>'get_keywords' }
    end
  end  

  def add_keywords   
    find_restaurant    
    UserMailer.deliver_add_keyword_request(@restaurant.name, params[:keywords])
    render :text=>"Request sent to admin,Wait for approval."  
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def require_manager
    find_restaurant
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end

end
