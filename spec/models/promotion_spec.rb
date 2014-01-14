require_relative '../spec_helper'
include ActionDispatch::Routing::UrlFor
include Rails.application.routes.url_helpers
default_url_options[:host] = DEFAULT_HOST

describe Promotion do
  it { should belong_to(:promotion_type) }
  it { should belong_to(:restaurant) }
  it { should have_many(:trace_keywords) }
  it { should have_many(:soapbox_trace_keywords) }    
  it { should have_many(:twitter_posts).dependent(:destroy) }
  it { should have_many(:facebook_posts).dependent(:destroy) }    
  it { should accept_nested_attributes_for(:twitter_posts).limit(3).allow_destroy(true) }
  it { should accept_nested_attributes_for(:facebook_posts).limit(3).allow_destroy(true) }    
  it { should validate_presence_of(:promotion_type) }
  it { should validate_presence_of(:details) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:restaurant_id) }
  it { should validate_presence_of(:headline) }
  it { should ensure_length_of(:headline).is_at_most(144) }
  it { should have_attached_file(:attachment) }
  it { should validate_attachment_content_type(:attachment).
                allowing("application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf")}

  before(:each) do
    promo_type = FactoryGirl.create(:promotion_type)
    @restaurant = FactoryGirl.create(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
    @valid_attributes = {
      :promotion_type_id => promo_type.id,
      :details => "value for details",
      :link => "value for link",
      :start_date => Date.today,
      :end_date => Date.today,
      :date_description => "value for date_description",
      :restaurant_id => @restaurant.id,
      :headline => "My great headline"
    }
    Promotion.any_instance.stubs(:restaurant).returns(@restaurant)
  end

  it "should create a new instance given valid attributes" do
    Promotion.create!(@valid_attributes)
  end


  describe ".current" do
    it "should return current" do
      promotion = FactoryGirl.build(:promotion)
      Promotion.current.should == Promotion.find(:all,:conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)", Date.today, Date.today],:order => "promotions.start_date ASC")
    end
  end

  describe ".recently_posted" do
    it "should return recently_posted" do
      promotion = FactoryGirl.build(:promotion)
      Promotion.recently_posted.should == Promotion.find(:all,:conditions => ["promotions.end_date >= ? OR (promotions.start_date >= ? AND promotions.end_date IS NULL)", Date.today, Date.today],:order => "promotions.start_date ASC")
    end
  end

  describe "#title" do
    it "should return title" do
      promotion = FactoryGirl.build(:promotion)
      promotion.title.should == promotion.promotion_type.try(:name)
    end
  end

  describe "#restaurant_name" do
    it "should return restaurant_name" do
      promotion = FactoryGirl.build(:promotion)
      promotion.restaurant_name.should == promotion.restaurant.name
    end
  end

  describe "#current?" do
    it "should return current?" do
      promotion = FactoryGirl.build(:promotion)
      promotion.current?.should == promotion.end_date.nil? ? promotion.start_date >= Date.today : promotion.end_date >= Date.today
    end
  end

  describe "#date_text" do
    it "should return date_text" do
      promotion = FactoryGirl.build(:promotion)
      text = promotion.start_date.to_formatted_s(:long)
      text << "- #{promotion.end_date.to_formatted_s(:long)}" if promotion.end_date.present?
      text << "- #{promotion.date_description}" if promotion.date_description.present?
      promotion.date_text.should == text
    end
  end

  describe "#activity_name" do
    it "should return activity_name" do
      promotion = FactoryGirl.build(:promotion)
      promotion.activity_name.should == "Newsfeed item"
    end
  end

  describe "#facebook_message" do
    it "should return facebook_message" do
      promotion = FactoryGirl.build(:promotion)
      promotion.facebook_message.should == "Newsfeed: #{promotion.title}"
    end
  end

  # it "should schedule a crosspost to Twitter" do
  #   twitter_client = mock
  #   @restaurant.stubs(:twitter_client).returns(twitter_client)
  #   # twitter_client.expects(:send_at).returns(true)
  #   Promotion.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
  # end
  # # #CIS crosspost flag remove
  # # it "should not crosspost to Twitter when no crosspost flag is set" do
  # #   @restaurant.expects(:twitter_client).never
  # #   Promotion.create(@valid_attributes.merge(:post_to_twitter_at => Time.now, :no_twitter_crosspost => "1"))
  # # end

  # it "should schedule a crosspost to Facebook" do
  #   # @restaurant.expects(:send_at).returns(true)
  #   Promotion.create(@valid_attributes.merge(:post_to_facebook_at => (Time.now + 5.hours)))
  # end
  # # #CIS crosspost flag remove
  # # it "should not crosspost to Facebook when no crosspost flag is set" do
  # #   @restaurant.expects(:send_at).never
  # #   Promotion.create(@valid_attributes.merge(:post_to_facebook_at => Time.now, :no_fb_crosspost => "1"))
  # # end

end

