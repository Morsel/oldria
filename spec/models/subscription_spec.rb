require_relative '../spec_helper'

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
          :end_date => Date.today - 1,
          :status => Subscription::Status::PAST_DUE)
      @past_due_subscription = Factory(:subscription,
          :end_date => 1.day.from_now,
          :status => Subscription::Status::PAST_DUE)
    end

    it "should destroy all subscriptions that are past due and ended before today" do
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
    
    let(:restaurant) { Factory(:restaurant) }
    let(:subscription) { Factory(:subscription, :subscriber => restaurant, 
        :payer => restaurant) }
    let(:user) { Factory(:user) }
    
    describe "create an add on" do
      
      it "adds the first payee correctly" do
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(subscription, 1)
        subscription.user_subscriptions_for_payer.size.should == 0
        subscription.add_staff_account(user)
      end
      
      describe "adding a subscription object to the new user" do
        
        before(:each) do
          BraintreeConnector.expects(:set_add_ons_for_subscription).with(
              subscription, 1).returns(stub(:success? => true))
          subscription.add_staff_account(user)
        end
        subject { user.subscription }
        its(:start_date) { should == Date.today }
        its(:payer) { should == restaurant }
        its(:kind) { should == "User Premium" }
        it { should be_staff_account }
        its(:end_date) { should be_nil }
        
      end
      
      it "adds the second payee correctly" do
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(subscription, 2)
        user_sub = Factory(:subscription, :subscriber => Factory(:user), :payer => restaurant)
        subscription.user_subscriptions_for_payer.size.should == 1
        subscription.add_staff_account(user)
      end
      
      it "does not add a payee if the subscription is a user" do
        subscription.update_attributes(:subscriber => Factory(:user))
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        subscription.add_staff_account(user)
      end
      
      it "does not add a payee if the subscription is past due" do
        subscription.update_attributes(:end_date => 1.day.ago)
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        subscription.add_staff_account(user)
      end
      
    end
    
    describe "remove an add on" do

      it "drops from three to two correctly" do
        subscription.update_attributes(:end_date => 2.weeks.from_now)
        user.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant, :start_date => 1.month.ago))
        user2 = Factory(:user)
        user2.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant))
        user3 = Factory(:user)
        user3.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant))
        Subscription.all.size.should == 4
        subscription.should have(3).user_subscriptions_for_payer
        Braintree::Subscription.expects(:update).with("abcd", 
            :add_ons => {:update => 
                [{:existing_id => "user_for_restaurant", :quantity => 2}]}).returns(
                success_stub)     
        subscription.remove_staff_account(user)
        subscription.should have(2).user_subscriptions_for_payer
        user.subscription.should == nil
        Subscription.all.size.should == 3
      end
      
      it "drops from two to one correctly" do
        subscription.update_attributes(:end_date => 2.weeks.from_now)
        user.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant, :start_date => 1.month.ago))
        user2 = Factory(:user)
        user2.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant))
        Subscription.all.size.should == 3
        subscription.should have(2).user_subscriptions_for_payer
        Braintree::Subscription.expects(:update).with("abcd", 
            :add_ons => {:update => 
                [{:existing_id => "user_for_restaurant", :quantity => 1}]}).returns(
                success_stub)     
        subscription.remove_staff_account(user)
        subscription.should have(1).user_subscriptions_for_payer
        user.subscription.should == nil
        Subscription.all.size.should == 2
      end

      it "drops from one to zero correctly" do
        subscription.update_attributes(:end_date => 2.weeks.from_now)
        user.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant, :start_date => 1.month.ago))
        Subscription.all.size.should == 2
        subscription.should have(1).user_subscriptions_for_payer
        Braintree::Subscription.expects(:update).with("abcd", 
            :add_ons => {:remove => ["user_for_restaurant"]}).returns(
                success_stub)     
        subscription.remove_staff_account(user)
        subscription.should have(0).user_subscriptions_for_payer
        user.subscription.should == nil
        Subscription.all.size.should == 1
      end
    end
  
  end
  
  describe "payer count " do
    
    let(:restaurant) { Factory(:restaurant) }
    let(:subscription) { Factory(:subscription, 
        :payer => restaurant, :subscriber => restaurant) }
        
    it "calculates the pay load count" do
      s1 = Factory(:subscription, :payer => restaurant, :subscriber => Factory(:user))
      s2 = Factory(:subscription, :payer => restaurant, :subscriber => Factory(:user))
      s1.user_subscriptions_for_payer.should have(2).items
      subscription.user_subscriptions_for_payer.should have(2).items
      s1.update_attributes(:payer => nil)
      subscription.user_subscriptions_for_payer.should have(1).item
      s2.user_subscriptions_for_payer.should have(1).item
    end
    
  end

end


