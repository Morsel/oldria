require_relative '../spec_helper'

describe MenuItem do
  before(:each) do
    @restaurant = Factory(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
    @valid_attributes = Factory.attributes_for(:menu_item, :otm_keywords => [Factory(:otm_keyword)], :restaurant => @restaurant)
    MenuItem.any_instance.stubs(:restaurant).returns(@restaurant)
  end

  it "should create a new instance given valid attributes" do
    MenuItem.create!(@valid_attributes)
  end

  it "should schedule a crosspost to Twitter" do
    twitter_client = mock
    @restaurant.stubs(:twitter_client).returns(twitter_client)
    twitter_client.expects(:send_at).returns(true)
    MenuItem.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
  end

  it "should not crosspost to Twitter when no crosspost flag is set" do
    @restaurant.expects(:twitter_client).never
    MenuItem.create(@valid_attributes.merge(:post_to_twitter_at => Time.now, :no_twitter_crosspost => "1"))
  end

  it "should schedule a crosspost to Facebook" do
    @restaurant.expects(:send_at).returns(true)
    MenuItem.create(@valid_attributes.merge(:post_to_facebook_at => (Time.now + 5.hours)))
  end

  it "should not crosspost to Facebook when no crosspost flag is set" do
    @restaurant.expects(:send_at).never
    MenuItem.create(@valid_attributes.merge(:post_to_facebook_at => Time.now, :no_fb_crosspost => "1"))
  end

end

