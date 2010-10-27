require 'spec_helper'

describe Subscription do
  before(:each) do
    @valid_attributes = {
      :braintree_id => "abcd",
      :start_date => Date.today
    }
  end

  describe "complimentary" do

    it "marks a subscription with no payer as complimentary" do
      subscription = Subscription.new(@valid_attribtes)
      subscription.should be_complimentary
    end

    it "marks a subscription with a payer as not complimentary" do
      subscription = Factory(:subscription, :payer => Factory(:user))
      subscription.should_not be_complimentary
    end

  end

  describe "active" do

    it "marks a subscription with no end date as active" do
      subscription = Subscription.new(@valid_attribtes)
      subscription.should be_active
      subscription.should_not be_in_overtime
    end

    it "marks a subscription with a past end date as inactive" do
      subscription = Factory(:subscription, :end_date => 1.year.ago)
      subscription.should_not be_active
      subscription.should_not be_in_overtime
    end

    it "marks a subscription with a future end date as active" do
      subscription = Factory(:subscription, :end_date => 1.year.from_now)
      subscription.should be_active
      subscription.should be_in_overtime
    end

  end

  describe "search for braintree data" do

    let(:subscription) { Subscription.new(@valid_attribtes) }

    it "calls braintree when requested" do
      BraintreeConnector.expects(:find_subscription).with(subscription)
      subscription.braintree_data
    end

    it "can set end date from braintree" do
      BraintreeConnector.expects(:find_subscription).with(subscription).returns(
          stub(:billing_period_end_date => 1.month.from_now.to_date))
      subscription.set_end_date_from_braintree
      subscription.end_date.should == 1.month.from_now.to_date
    end

  end

  describe "#past_due!" do

    let(:subscription) { Factory(:subscription) }

    before(:each) do
      subscription.past_due!
    end

    it "updates status to past_due" do
      subscription.status.should == Subscription::Status::PAST_DUE
    end
    it "sets end date to 5 days from today" do
      subscription.end_date.should == 5.days.from_now.to_date
    end
  end

  describe "#purge_expired!" do
    before(:each) do
      @expired_subscription = Factory(:subscription,
          :end_date => 1.day.ago,
          :status => Subscription::Status::PAST_DUE)
      @past_due_subscription = Factory(:subscription,
          :end_date => Date.today,
          :status => Subscription::Status::PAST_DUE)
    end

    it "should destroy all subscriptions that are more than 5 days past due" do
      Subscription.purge_expired!
      Subscription.all.should == [@past_due_subscription]
    end
  end

  describe "needs braintree cancel" do

    let(:subscription) { Subscription.new(@valid_attribtes) }

    it "a regular subscription needs a braintree cancel" do
      subscription.payer = Factory(:user)
      subscription.skip_braintree_cancel?.should be_false
    end

    it "a complimentary account does not need a braintree cancel" do
      subscription.payer = nil
      subscription.skip_braintree_cancel?.should be_true
    end

    it "an overtime account does not need a braintree cancel" do
      subscription.payer = Factory(:user)
      subscription.end_date = 1.month.from_now
      subscription.skip_braintree_cancel?.should be_true
    end

  end
  
  describe "add ons" do
    
    describe "create an add on" do
      let(:restaurant) { Factory(:restaurant) }
      let(:subscription) { Factory(:subscription, :subscriber => restaurant, :payer => restaurant) }
      let(:user) { Factory(:user) }
      
      it "adds the first payee correctly" do
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(subscription, 1)
        subscription.user_subscriptions_for_payer.size == 0
        subscription.add_payee(user)
      end
      
      it "adds the second payee correctly" do
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(subscription, 2)
        user_sub = Factory(:subscription, :subscriber => Factory(:user), :payer => restaurant)
        subscription.user_subscriptions_for_payer.size == 1
        subscription.add_payee(user)
      end
      
      it "does not add a payee if the subscription is a user" do
        subscription.update_attributes(:payer => Factory(:user))
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        subscription.add_payee(user)
      end
      
      it "does not add a payee if the subscription is past due" do
        subscription.update_attributes(:end_date => 1.day.ago)
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        subscription.add_payee(user)
      end
      
    end
    
  end

end

# == Schema Information
#
# Table name: subscriptions
#
#  id              :integer         not null, primary key
#  braintree_id    :string(255)
#  start_date      :date
#  subscriber_id   :integer
#  subscriber_type :string(255)
#  payer_id        :integer
#  payer_type      :string(255)
#  kind            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  end_date        :date
#

