require 'spec_helper'

describe SubscriptionsControllerHelper do
  include SubscriptionsControllerHelper

  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(SubscriptionsControllerHelper)
  end

  context "when subscriber is a user" do
    let(:subscriber) { Factory(:user) }
    describe "#billing_history_path" do
      it "should return user billing history path" do
        billing_history_path(subscriber).should == user_billing_history_path(subscriber)
      end
    end
  end

  context "when subscriber is a restaurant" do
    let(:subscriber) { Factory(:restaurant) }
    describe "#billing_history_path" do
      it "should return restaurant billing history path" do
        billing_history_path(subscriber).should == restaurant_billing_history_path(subscriber)
      end
    end
  end

  describe "#obscure_credit_card_number" do
    let(:credit_card) { stub(:last_4 => 1111) }
    it "should only display the last 4 digits" do
      obscure_credit_card_number(credit_card).should == "...1111"
    end
  end

end
