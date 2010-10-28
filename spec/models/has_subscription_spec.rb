require 'spec/spec_helper'

describe HasSubscription do
  
  describe "with a user" do
    describe "make a subscription" do
      let(:user) { Factory(:user) }
      let(:bt_sub) { stub(:subscription => stub(:id => "abcd")) }

      before(:each) do
        user.make_premium!(bt_sub)
      end

      subject { user.subscription }
      its(:start_date) { should == Date.today }
      its(:subscriber) { should == user }
      its(:payer) { should == user }
      its(:kind) { should == "User Premium" }
      its(:braintree_id) { should == "abcd" }
      it { should be_premium }
      it { should_not be_complimentary }
    end

    describe "make a complimentary subscription for a user without one" do

      let(:user) { Factory(:user) }

      before(:each) do
        user.make_complimentary!
      end

      subject { user.subscription }
      its(:start_date) { should == Date.today }
      its(:subscriber) { should == user }
      its(:payer) { should be_nil }
      its(:kind) { should == "User Premium" }
      its(:braintree_id) { should be_nil }
      it { should be_premium }
      it { should be_complimentary }

    end

    describe "make a complimentary subscription for a user with one" do

      let(:user) { Factory(:user) }

      before(:each) do
        user.subscription = Factory(:subscription, :payer => user)
        user.save!
        user.make_complimentary!
      end

      specify { Subscription.all.size.should == 1 }

    end

    describe "cancel subscription" do

      let(:user) { Factory(:user) }

      before(:each) do
        user.subscription = Factory(:subscription, :payer => user)
        user.save!
      end

      context "with immediate termination" do

        before(:each) do
          user.cancel_subscription!(:terminate_immediately => true)
        end

        specify { user.subscription.should == nil }
        specify { Subscription.all.size.should == 0 }

      end
      
      context "of a complimentary subscription" do
        
        before(:each) do
          user.subscription = Factory(:subscription, :payer => nil)
          user.subscription.expects(:set_end_date_from_braintree).never
          user.cancel_subscription!(:terminate_immediately => false)
        end
        
        it "makes a complimentary subscription last one month" do
          user.subscription.end_date.should == 1.month.from_now.to_date
        end
        
      end

      context "with delayed termination" do

        before(:each) do
          BraintreeConnector.expects(:find_subscription).with(user.subscription).returns(
              stub(:billing_period_end_date => 1.month.from_now.to_date))
          user.cancel_subscription!(:terminate_immediately => false)
        end

        it "correctly manages the user subscription" do
          user.subscription.end_date.should == 1.month.from_now.to_date
          Subscription.all.size.should == 1
        end

      end

    end
  end
  
  describe "with a restaurant" do
    
    describe "make a subscription" do
      let(:restaurant) { Factory(:restaurant) }
      let(:bt_sub) { stub(:subscription => stub(:id => "abcd")) }

      before(:each) do
        restaurant.make_premium!(bt_sub)
      end

      subject { restaurant.subscription }
      its(:start_date) { should == Date.today }
      its(:subscriber) { should == restaurant }
      its(:payer) { should == restaurant }
      its(:kind) { should == "Restaurant Premium" }
      its(:braintree_id) { should == "abcd" }
      it { should be_premium }
      it { should_not be_complimentary }
    end
    
    describe "make a complimentary subscription for a restaurant without one" do

      let(:restaurant) { Factory(:restaurant) }

      before(:each) do
        restaurant.make_complimentary!
      end

      subject { restaurant.subscription }
      its(:start_date) { should == Date.today }
      its(:subscriber) { should == restaurant }
      its(:payer) { should be_nil }
      its(:kind) { should == "Restaurant Premium" }
      its(:braintree_id) { should be_nil }
      it { should be_premium }
      it { should be_complimentary }

    end
    
  end
  
  describe "make a staff account" do
    
    let(:restaurant) { Factory(:restaurant) }
    let(:user) { Factory(:user) }
    
    describe "happy path" do
      
      before(:each) {
        user.make_staff_account!(restaurant)
      }
      subject { user.subscription }
      its(:start_date) { should == Date.today }
      its(:subscriber) { should == user }
      its(:payer) { should == restaurant }
      its(:kind) { should == "User Premium" }
      it { should be_staff_account }
      its(:end_date) { should be_nil }
      
    end
    
    #TODO: What if the cancel fails after the add on has gone through?
    describe "user already has an account so keep old data" do
      let(:bt_sub) { stub(:subscription => stub(:id => "abcd")) }
      
      before(:each) do
        BraintreeConnector.expects(:cancel_subscription => stub(:success? => true))
        user.make_premium!(bt_sub)
        user.subscription.update_attributes(:start_date => 1.month.ago.to_date)
        user.make_staff_account!(restaurant)
      end
      
      subject { user.subscription }
      its(:start_date) { should == 1.month.ago.to_date }
      its(:subscriber) { should == user }
      its(:payer) { should == restaurant }
      its(:kind) { should == "User Premium" }
      it { should be_staff_account }
      its(:end_date) { should be_nil }
      
    end
    
    describe "sad paths" do
      
      it "blocks if user and restaurant are in the wrong place" do
        restaurant.make_staff_account!(user).should be_nil
        restaurant.make_staff_account!(restaurant).should be_nil
        user.make_staff_account!(user).should be_nil
      end
      
    end
    
  end
  
  describe "update_complimentary_with_braintree_id" do
    
    let(:restaurant) { Factory(:restaurant) }

    before(:each) do
      restaurant.make_complimentary!
      restaurant.update_complimentary_with_braintree_id!("abcd")
    end
    
    subject { restaurant.subscription }
    its(:start_date) { should == Date.today }
    its(:subscriber) { should == restaurant }
    its(:payer) { should be_nil }
    its(:kind) { should == "Restaurant Premium" }
    its(:braintree_id) { should == "abcd" }
    it { should be_premium }
    it { should be_complimentary }
    
  end
  
end