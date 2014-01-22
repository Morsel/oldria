require_relative '../spec_helper'

describe NewsletterSubscription do
  it { should belong_to(:restaurant) }
  it { should belong_to(:newsletter_subscriber) }
  it { should validate_uniqueness_of(:newsletter_subscriber_id).scoped_to(:restaurant_id) }

  before(:each) do
    @restaurant = FactoryGirl.create(:restaurant)
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

   # NewsletterSubscription.create!(@valid_attributes)
  end


end
