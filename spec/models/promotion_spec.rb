require 'spec_helper'

describe Promotion do
  before(:each) do
    promo_type = Factory(:promotion_type)
    @restaurant = Factory(:restaurant)
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
  end

  it "should create a new instance given valid attributes" do
    Promotion.create!(@valid_attributes)
  end

  it "should schedule a crosspost to Twitter" do
    Promotion.any_instance.stubs(:restaurant).returns(@restaurant)
    twitter_client = mock
    @restaurant.stubs(:twitter_client).returns(twitter_client)
    twitter_client.expects(:send_at).returns(true)
    Promotion.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
  end

end

