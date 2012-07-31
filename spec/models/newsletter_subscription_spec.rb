require 'spec_helper'

describe NewsletterSubscription do
  before(:each) do
    @valid_attributes = {
      :restaurant_id => 1,
      :newsletter_subscriber_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    NewsletterSubscription.create!(@valid_attributes)
  end
end
