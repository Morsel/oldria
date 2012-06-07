require 'spec_helper'

describe MenuItem do
  before(:each) do
    @restaurant = Factory(:restaurant, :atoken => "asdfgh", :asecret => "1234567")
    @valid_attributes = Factory.attributes_for(:menu_item, :otm_keywords => [Factory(:otm_keyword)], :restaurant => @restaurant)
  end

  it "should create a new instance given valid attributes" do
    MenuItem.create!(@valid_attributes)
  end

  it "should schedule a crosspost to Twitter" do
    MenuItem.any_instance.stubs(:restaurant).returns(@restaurant)
    twitter_client = mock
    @restaurant.stubs(:twitter_client).returns(twitter_client)
    twitter_client.expects(:send_at).returns(true)
    MenuItem.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
  end

end

