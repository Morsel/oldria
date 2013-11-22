class Soapbox::SoapboxEntriesController < Soapbox::SoapboxController
  include RiaCaching
  before_filter :hide_flashes

  caches_action :index,                
                :expires_in => 10.minutes,
                :cache_path => Proc.new { |controller| controller.dashboard_cache_key }

  def initialize
    @per_page = 10
  end

  def index
    @main_feature = SoapboxEntry.main_feature
    @main_feature_comments = SoapboxEntry.main_feature_comments if @main_feature

    @secondary_feature = SoapboxEntry.secondary_feature
    @secondary_feature_comments = SoapboxEntry.secondary_feature_comments if @secondary_feature
    render :layout =>"soapbox"
  end

  def dashboard_cache_key
    cache_key(controller_name, :index)
  end

  def show
    @entry = SoapboxEntry.find(params[:id], :include => :featured_item)
    @feature = @entry.featured_item
    @feature_comments = @entry.comments.all(:order => "created_at DESC")
    @feature_type = @entry.featured_item_type == 'Admin::Qotd' ? ' Question of the Day' : ' Trend'
    render :layout => 'soapbox'
  end

  def trend
    if params[:view_all]
      @featured_items = TrendQuestion.current.all(:order => "created_at DESC").paginate(:page => params[:page])
    else
      questions = SoapboxEntry.trend_question.published
      @featured_items = questions.map(&:featured_item).paginate(:page => params[:page], :include => :featured_item)
    end
    @no_sidebar = true
    render :layout =>"soapbox"
  end

  def qotd
    if params[:view_all]
      @featured_items = Admin::Qotd.current.all(:order => "created_at DESC", :limit => 10).paginate(:page => params[:page])
    else
      questions = SoapboxEntry.qotd.published
      @featured_items = questions.map(&:featured_item).paginate(:page => params[:page], :include => :featured_item)
    end
    @no_sidebar = true
    render :layout =>"soapbox"
  end

  def comment
    @entry = SoapboxEntry.find(params[:id], :include => :featured_item)
    @feature = @entry.featured_item
    @feature_comments = [Comment.find(params[:comment_id])]
    @feature_type = @entry.featured_item_type == 'Admin::Qotd' ? ' Question of the Day' : ' Trend'
    @comment_view = true
    @user = @feature_comments.first.user
    if @user.completed_setup? && @user.primary_restaurant? && @user.primary_restaurant.premium_account? && @user.linkable_profile?
      primary_restaurant = @user.primary_restaurant
      @menu_items = primary_restaurant.menu_items.all(:order => "created_at DESC",:limit => 3)
      @promotions = primary_restaurant.promotions.all(:limit=>3,:order=>"created_at DESC",:conditions=>["DATE(promotions.start_date) >= DATE(?)", Time.now])
      @user_answers = primary_restaurant.a_la_minute_answers.all(:limit=>3,:order => "a_la_minute_answers.created_at DESC",:conditions=>["DATE(a_la_minute_answers.created_at) = DATE(?)", Time.now])
    end
    @more_comments  = @entry.comments.all(:order => "created_at DESC") - @feature_comments
    
    render :action => "show",:layout => 'soapbox'
  end

  def frontburner
    @announcements = []

    @soapbox_comments   = SoapboxEntry.published.all(:limit => @per_page, :order => "published_at DESC").map(&:comments)
    @answers            = ProfileAnswer.from_premium_users.all(:limit => @per_page, :order => "created_at DESC")
    @menu_items         = MenuItem.activated_restaurants.from_premium_restaurants.all(:limit => @per_page, :order => "menu_items.created_at DESC")
    @promotions         = Promotion.from_premium_restaurants.all(:limit => @per_page, :order => "created_at DESC")
    @restaurant_answers = RestaurantAnswer.activated_restaurants.from_premium_restaurants.all(:limit => @per_page, :order => "restaurant_answers.created_at DESC")



    @main_feature = SoapboxEntry.main_feature
    @main_feature_comments = SoapboxEntry.main_feature_comments if @main_feature

    @secondary_feature = SoapboxEntry.secondary_feature
    @secondary_feature_comments = SoapboxEntry.secondary_feature_comments if @secondary_feature
    render 'dashboard', :layout =>"soapbox"
  end
  protected

  def hide_flashes
    @hide_flashes = true
  end

end
