require_relative '../spec_helper'

describe MediaNewsletterSubscription do
  it { should belong_to :restaurant }
	it { should belong_to :media_newsletter_subscriber }

   before do
    @restaurant = FactoryGirl.create(:restaurant, :name => "Megan's Place")
   end

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:media_newsletter_subscription)
  end

  it "should create a new instance given valid attributes" do
   # MediaNewsletterSubscription.create!(@valid_attributes)
  end

  describe "#send_newsletters_to_media" do
    it "should return newsletters_to_media" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      user1 = FactoryGirl.create(:user,:role=>"media")
      user2 = FactoryGirl.create(:user,:role=>"media")
      User.find(:all,:conditions=>["role = 'media'"]).each do |user|
        if user.media_newsletter_setting.blank?  
          FactoryGirl.create(:media_newsletter_setting,:user=>user)
        end
        arrMedia=[]    
        arrMedia.push(user.media_newsletter_subscriptions.map(&:restaurant))
        arrMedia.push(user.get_digest_subscription)
        arrMedia.flatten!
        unless MediaNewsletterSubscription.menu_items(arrMedia).blank? && MediaNewsletterSubscription.promotions(arrMedia).blank?
          user.send_later(:send_newsletter_to_media_subscribers,user) if (!user.media_newsletter_setting.opt_out) && (!["Sun","Sat"].include?(Date::ABBR_DAYNAMES[Date.today.wday]))
        end
      end   
    end
  end

  describe "#menu_items" do
    it "should return menu_items" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      restaurant1 = FactoryGirl.create(:restaurant)
      restaurant2 = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.all
      menu_items = []
      if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
        menu_items =MenuItem.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),"2","2"],:order=>"updated_at desc",:limit=>3)
      else
        menu_items =MenuItem.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),"1","1"],:order=>"updated_at desc",:limit=>3)
      end   
      menu_items.flatten.compact
      MediaNewsletterSubscription.menu_items(restaurants).should ==  menu_items
    end
  end

  describe ".menus" do
    it "should return menus" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      restaurant1 = FactoryGirl.create(:restaurant)
      restaurant2 = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.all
      menus = []
      restaurants.each do |restaurant|
        menus.push(restaurant.menus.all(:order=>"created_at desc" ,:limit=>3))
      end   
      MediaNewsletterSubscription.menus(restaurants).should == menus.flatten.compact

    end
  end

  describe ".restaurant_answers" do
    it "should return restaurant_answers" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      restaurant1 = FactoryGirl.create(:restaurant)
      restaurant2 = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.all
      restaurant_answers = []
      restaurants.each do |restaurant|
        restaurant_answers.push(restaurant.a_la_minute_answers.all(:order=>"created_at desc" ,:limit=>3))
      end   
      MediaNewsletterSubscription.restaurant_answers(restaurants).should ==  restaurant_answers.flatten.compact
    end
  end

  describe ".promotions" do
    it "should return promotions" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      restaurant1 = FactoryGirl.create(:restaurant)
      restaurant2 = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.all
      promotions = []
      if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
        promotions =Promotion.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),"2","2"],:order=>"updated_at desc",:limit=>3)
      else
        promotions =Promotion.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),"1","1"],:order=>"updated_at desc",:limit=>3)
      end  
      MediaNewsletterSubscription.promotions(restaurants).should == promotions.flatten.compact
    end
  end

  describe ".newsletter_menus" do
    it "should return newsletter_menus" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      restaurant1 = FactoryGirl.create(:restaurant)
      restaurant2 = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.all
      newsletter_menus = []
      if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
        newsletter_menus =Menu.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),"2","2"],:order=>"updated_at desc",:limit=>3)
      else
        newsletter_menus =Menu.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),"1","1"],:order=>"updated_at desc",:limit=>3)
      end  
      MediaNewsletterSubscription.newsletter_menus(restaurants).should == newsletter_menus.flatten.compact
    end
  end

  describe ".fact_sheets" do
    it "should return fact_sheets" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      restaurant1 = FactoryGirl.create(:restaurant)
      restaurant2 = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.all
      fact_sheets = []
      if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
        fact_sheets =RestaurantFactSheet.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.map(&:id),"2","2"],:order=>"updated_at desc",:limit=>3) 
      else
        fact_sheets =RestaurantFactSheet.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),"1","1"],:order=>"updated_at desc",:limit=>3)
      end  
      MediaNewsletterSubscription.fact_sheets(restaurants).should == fact_sheets.flatten.compact
    end
  end

  describe ".photos" do
    it "should return photos" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
      restaurant1 = FactoryGirl.create(:restaurant)
      restaurant2 = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.all
      photos = []
      restaurants.each do |restaurant|  
        photos.push(restaurant.photos.find(:all,:conditions=>["(created_at >= ? OR updated_at >= ?) ",1.day.ago.beginning_of_day,1.day.ago.beginning_of_day],:order=>"updated_at desc",:limit=>3))
      end 
      MediaNewsletterSubscription.photos(restaurants).should == photos.flatten.compact
    end
  end

  describe ".get_limit_day" do
    it "should return get_limit_day" do
      media_newsletter_subscription = FactoryGirl.create(:media_newsletter_subscription)
       if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
        value = 2
      else
        value = 1  
      end 
      MediaNewsletterSubscription.get_limit_day.should == value
    end
  end


end 
