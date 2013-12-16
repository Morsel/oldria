require_relative '../../spec_helper'

describe Soapbox::NewsletterSubscriptionsController do

  it "should allow a newsletter subscriber to opt in to having their email shared with the restaurant" do
    restaurant = FactoryGirl.create(:restaurant)
    subscriber = FactoryGirl.create(:newsletter_subscriber)

    # MailchimpConnector.stubs(:new).returns(mc = mock)
    # mc.stubs(:client).returns(client = mock)
    # mc.stubs(:mailing_list_id).returns(1234)

    # client.stubs(:list_interest_groupings).returns("#{restaurant.name} in #{restaurant.city} #{restaurant.state}")
    # client.stubs(:list_update_member).returns(true)

    subscription = NewsletterSubscription.create(:newsletter_subscriber => subscriber, :restaurant => restaurant)
    put :update, :id => subscription.id, "newsletter_subscription" => { "share_with_restaurant" => "1" }
    subscription.reload.share_with_restaurant.should == true
  end

end
