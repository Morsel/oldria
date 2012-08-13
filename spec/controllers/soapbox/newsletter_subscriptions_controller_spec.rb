require 'spec_helper'

describe Soapbox::NewsletterSubscriptionsController do

  it "should allow a newsletter subscriber to opt in to having their email shared with the restaurant" do
    restaurant = Factory(:restaurant)
    subscriber = Factory(:newsletter_subscriber)
    subscription = NewsletterSubscription.create(:newsletter_subscriber => subscriber, :restaurant => restaurant)
    put :update, :id => subscription.id, "newsletter_subscription" => { "share_with_restaurant" => "1" }
    subscription.reload.share_with_restaurant.should == true
  end

end
