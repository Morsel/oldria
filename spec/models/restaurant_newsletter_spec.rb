require_relative '../spec_helper'

describe RestaurantNewsletter do
  it { should belong_to(:restaurant) }
  it { should serialize(:menu_item_ids) }
  it { should serialize(:restaurant_answer_ids) }
  it { should serialize(:menu_ids) }
  it { should serialize(:promotion_ids) }
  it { should serialize(:a_la_minute_answer_ids) }

  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantNewsletter.create!(@valid_attributes)
  end
  
  describe "#menu_items" do
    it "should return menu_items" do
      restaurant_newsletter = FactoryGirl.create(:restaurant_newsletter)
      restaurant_newsletter.menu_items.should == MenuItem.find(:all,:conditions=>["id in(?)",restaurant_newsletter.menu_item_ids])
    end
  end

  describe "#restaurant_answers" do
    it "should return restaurant_answers" do
      restaurant_newsletter = FactoryGirl.create(:restaurant_newsletter)
      restaurant_newsletter.restaurant_answers.should == RestaurantAnswer.find(:all,:conditions=>["id in(?)",restaurant_newsletter.restaurant_answer_ids])
    end
  end

  describe "#menus" do
    it "should return menus" do
      restaurant_newsletter = FactoryGirl.create(:restaurant_newsletter)
      restaurant_newsletter.menus.should == Menu.find(:all,:conditions=>["id in(?)",restaurant_newsletter.menu_ids])
    end
  end

  describe "#promotions" do
    it "should return promotions" do
      restaurant_newsletter = FactoryGirl.create(:restaurant_newsletter)
      restaurant_newsletter.promotions.should == Promotion.find(:all,:conditions=>["id in(?)",restaurant_newsletter.promotion_ids])
    end
  end

  describe "#a_la_minute_answers" do
    it "should return a_la_minute_answers" do
      restaurant_newsletter = FactoryGirl.create(:restaurant_newsletter)
      restaurant_newsletter.a_la_minute_answers.should == ALaMinuteAnswer.find(:all,:conditions=>["id in(?)",restaurant_newsletter.a_la_minute_answer_ids])
    end
  end

  describe ".create_with_content" do
    it "should return create_with_content" do
      restaurant_newsletter = FactoryGirl.create(:restaurant_newsletter)
      restaurant = FactoryGirl.create(:restaurant)
      if restaurant.restaurant_newsletters.blank?
        filter_date = 7.day.ago
      else
        filter_date = restaurant.restaurant_newsletters.find(:all,:order => "created_at desc").first.created_at
      end   
      RestaurantNewsletter.create_with_content(restaurant_id).should ==  filter_date
    end
  end


end
