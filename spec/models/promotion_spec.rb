require_relative '../spec_helper'

describe Promotion do
  before(:each) do
    promo_type = Factory(:promotion_type)
    @restaurant = Factory(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
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

  it "should schedule a crosspost to Twitter" do
    twitter_client = mock
    @restaurant.stubs(:twitter_client).returns(twitter_client)
    twitter_client.expects(:send_at).returns(true)
    Promotion.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
  end

  it "should not crosspost to Twitter when no crosspost flag is set" do
    @restaurant.expects(:twitter_client).never
    Promotion.create(@valid_attributes.merge(:post_to_twitter_at => Time.now, :no_twitter_crosspost => "1"))
  end

  it "should schedule a crosspost to Facebook" do
    @restaurant.expects(:send_at).returns(true)
    Promotion.create(@valid_attributes.merge(:post_to_facebook_at => (Time.now + 5.hours)))
  end

  it "should not crosspost to Facebook when no crosspost flag is set" do
    @restaurant.expects(:send_at).never
    Promotion.create(@valid_attributes.merge(:post_to_facebook_at => Time.now, :no_fb_crosspost => "1"))
  end

end

