require_relative '../spec_helper'

describe NewsletterSubscription do
  before(:each) do
    @restaurant = Factory(:restaurant)
    @valid_attributes = {
      :restaurant_id => @restaurant.id,
      :newsletter_subscriber_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    MailchimpConnector.stubs(:new).returns(mc = mock)
    mc.stubs(:client).returns(client = mock)
    mc.stubs(:mailing_list_id).returns(1234)

    client.stubs(:list_interest_groupings).returns("#{@restaurant.name} in #{@restaurant.city} #{@restaurant.state}")
    client.stubs(:list_update_member).returns(true)

    NewsletterSubscription.create!(@valid_attributes)
  end
end
