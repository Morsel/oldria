require_relative '../spec_helper'

describe SubscriptionsControllerHelper do
  include SubscriptionsControllerHelper

  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(SubscriptionsControllerHelper)
  end

  context "when subscriber is a user" do
    let(:subscriber) { Factory(:user) }

    describe "#subscription_path" do
      it "should return user billing history path" do
        subscription_path(subscriber).should == user_subscription_path(subscriber)
      end
    end

    describe "#edit_subscription_path" do
      it "should return edit user subscription path" do
        edit_subscription_path(subscriber).should == edit_user_subscription_path(subscriber)
      end
    end

    describe "#new_subscription_path" do
      it "should return new user subscription path" do
        new_subscription_path(subscriber).should == new_user_subscription_path(subscriber)
      end
    end

    describe "#billing_history_subscription_path" do
      it "should return user billing history path" do
        billing_history_subscription_path(subscriber).should == billing_history_user_subscription_path(subscriber)
      end
    end

    describe "#bt_callback_subscription_url" do
      it "should return user bt callback url" do
        bt_callback_subscription_url(subscriber).should == bt_callback_user_subscription_url(subscriber)
      end
    end


  end

  context "when subscriber is a restaurant" do
    let(:subscriber) { Factory(:restaurant) }

    describe "#subscription_path" do
      it "should return restaurant billing history path" do
        subscription_path(subscriber).should == restaurant_subscription_path(subscriber)
      end
    end

    describe "#edit_subscription_path" do
      it "should return restaurant edit user subscription path" do
        edit_subscription_path(subscriber).should == edit_restaurant_subscription_path(subscriber)
      end
    end

    describe "#new_subscription_path" do
      it "should return new restaurant subscription path" do
        new_subscription_path(subscriber).should == new_restaurant_subscription_path(subscriber)
      end
    end

    describe "#billing_history_path" do
      it "should return restaurant billing history path" do
        billing_history_subscription_path(subscriber).should == billing_history_restaurant_subscription_path(subscriber)
      end
    end

    describe "#bt_callback_subscription_url" do
      it "should return restaurant bt callback url" do
        bt_callback_subscription_url(subscriber).should == bt_callback_restaurant_subscription_url(subscriber)
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
