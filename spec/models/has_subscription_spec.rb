require 'spec/spec_helper'

describe HasSubscription do
  
  describe "with a user" do
    describe "make a subscription" do
      let(:user) { Factory(:user) }

      before(:each) do
        user.make_premium!(subscription_response_stub)
      end
      
      it "creates the right subscription" do
        user.subscription.start_date.should == Date.today
        user.subscription.subscriber.should == user
        user.subscription.payer.should == user
        user.subscription.kind.should == "User Premium"
        user.subscription.braintree_id.should == "abcd"
        user.subscription.should be_premium
        user.subscription.should_not be_complimentary
      end
    end

    describe "make a complimentary subscription for a user without one" do

      let(:user) { Factory(:user) }

      before(:each) do
        BraintreeConnector.expects(:update_subscription_with_discount).never
        BraintreeConnector.expects(:cancel_subscription).never
        user.make_complimentary!
      end
      
      it "creates the right subscription" do
        user.subscription.start_date.should == Date.today
        user.subscription.subscriber.should == user
        user.subscription.payer.should be_nil
        user.subscription.kind.should == "User Premium"
        user.subscription.braintree_id.should be_nil
        user.subscription.should be_premium
        user.subscription.should be_complimentary
      end

    end

    describe "make a complimentary subscription for a user with a paid one" do

      let(:user) { Factory(:user) }

      before(:each) do
        BraintreeConnector.expects(:update_subscription_with_discount).never
        user.subscription = Factory(:subscription, :payer => user)
        BraintreeConnector.expects(:cancel_subscription).with(
            user.subscription).returns(success_stub)
        user.save!
        user.make_complimentary!
      end

      specify { Subscription.all.size.should == 1 }

    end
    
    describe "make a complimentary subscription for a user that has a staff account" do
      let(:restaurant) { Factory(:restaurant) }
      let(:user) { Factory(:user) }
      
      before(:each) do
        user.make_staff_account!(restaurant)
        user.subscription.update_attributes(:start_date => 1.month.ago.to_date)
        restaurant.update_attributes(
            :subscription => Factory(:subscription, :payer => restaurant,
                :start_date => 1.month.ago.to_date, :kind => "Restaurant Premium"))
        BraintreeConnector.expects(:update_subscription_with_discount).never
        BraintreeConnector.expects(:cancel_subscription).never
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(
            restaurant.subscription, 0).returns(stub(:success? => true))
        user.make_complimentary!
      end
      
      it "creates the right subscription" do
        user.subscription.start_date.should == 1.month.ago.to_date
        user.subscription.subscriber.should == user
        user.subscription.payer.should be_nil
        user.subscription.kind.should == "User Premium"
        user.subscription.braintree_id.should be_nil
        user.subscription.should be_premium
        user.subscription.should be_complimentary
      end
      
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
  
      before(:each) do
        restaurant.make_premium!(subscription_response_stub)
      end
      
      it "creates the right subscription" do
        restaurant.subscription.start_date.should == Date.today
        restaurant.subscription.subscriber.should == restaurant
        restaurant.subscription.payer.should == restaurant
        restaurant.subscription.kind.should == "Restaurant Premium"
        restaurant.subscription.braintree_id.should == "abcd"
        restaurant.subscription.should be_premium
        restaurant.subscription.should_not be_complimentary
      end
    end
    
    describe "make a complimentary subscription for a restaurant without one" do

      let(:restaurant) { Factory(:restaurant) }

      before(:each) do
        BraintreeConnector.expects(:update_subscription_with_discount).never
        BraintreeConnector.expects(:cancel_subscription).never
        restaurant.make_complimentary!
      end
      
      it "creates the right subscription" do
        restaurant.subscription.start_date.should == Date.today
        restaurant.subscription.subscriber.should == restaurant
        restaurant.subscription.payer.should be_nil
        restaurant.subscription.kind.should == "Restaurant Premium"
        restaurant.subscription.braintree_id.should be_nil
        restaurant.subscription.should be_premium
        restaurant.subscription.should be_complimentary
      end

    end
    
    describe "make a complimentary account for a restaurant with a paid one and staff accounts" do
      
      let(:restaurant) { Factory(:restaurant) }
      let(:user) { Factory(:user) }
      
      before(:each) do
        user.make_staff_account!(restaurant)
        restaurant.update_attributes(
            :subscription => Factory(:subscription, :payer => restaurant,
                :start_date => 1.month.ago.to_date, :kind => "Restaurant Premium"))
        BraintreeConnector.expects(:update_subscription_with_discount).with(
            restaurant.subscription).returns(success_stub)
        BraintreeConnector.expects(:cancel_subscription).never
        restaurant.make_complimentary!
      end
      
      it "creates the right subscription" do
        restaurant.subscription.start_date.should == 1.month.ago.to_date
        restaurant.subscription.subscriber.should == restaurant
        restaurant.subscription.payer.should be_nil
        restaurant.subscription.kind.should == "Restaurant Premium"
        restaurant.subscription.braintree_id.should == "abcd"
        restaurant.subscription.should be_premium
        restaurant.subscription.should be_complimentary
      end
    
    end
    
    describe "make a complimentary account for a restaurant with a paid one and no staff accounts" do
      
      let(:restaurant) { Factory(:restaurant) }
      
      before(:each) do
        restaurant.update_attributes(
            :subscription => Factory(:subscription, :payer => restaurant,
                :start_date => 1.month.ago.to_date, :kind => "Restaurant Premium"))
        BraintreeConnector.expects(:update_subscription_with_discount).never
        BraintreeConnector.expects(:cancel_subscription).with(
            restaurant.subscription).returns(success_stub)
        restaurant.make_complimentary!
      end
      
      it "creates the right subscription" do
        restaurant.subscription.start_date.should == 1.month.ago.to_date
        restaurant.subscription.subscriber.should == restaurant
        restaurant.subscription.payer.should be_nil
        restaurant.subscription.kind.should == "Restaurant Premium"
        restaurant.subscription.braintree_id.should be_nil
        restaurant.subscription.should be_premium
        restaurant.subscription.should be_complimentary
      end
    
    end
    
  end
  
  describe "make a staff account" do
    
    let(:restaurant) { Factory(:restaurant) }
    let(:user) { Factory(:user) }
    
    describe "happy path" do
      
      before(:each) {
        user.make_staff_account!(restaurant)
      }
      
      it "creates the right subscription" do
        user.subscription.start_date.should == Date.today
        user.subscription.subscriber.should == user
        user.subscription.payer.should == restaurant
        user.subscription.kind.should == "User Premium"
        user.subscription.braintree_id.should be_nil
        user.subscription.end_date.should be_nil
        user.subscription.should be_staff_account
      end
      
    end
    
    #TODO: What if the cancel fails after the add on has gone through?
    describe "user already has an account so keep old data" do
      
      before(:each) do
        BraintreeConnector.expects(:cancel_subscription => success_stub)
        user.make_premium!(subscription_response_stub)
        user.subscription.update_attributes(:start_date => 1.month.ago.to_date)
        user.make_staff_account!(restaurant)
      end
      
      it "creates the right subscription" do
        user.subscription.start_date.should == 1.month.ago.to_date
        user.subscription.subscriber.should == user
        user.subscription.payer.should == restaurant
        user.subscription.kind.should == "User Premium"
        user.subscription.braintree_id.should be_nil
        user.subscription.should be_premium
        user.subscription.should be_staff_account
      end
      
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
    
    it "creates the right subscription" do
      restaurant.subscription.start_date == Date.today
      restaurant.subscription.subscriber.should == restaurant
      restaurant.subscription.payer.should be_nil
      restaurant.subscription.kind.should == "Restaurant Premium"
      restaurant.subscription.braintree_id.should == "abcd"
      restaurant.subscription.should be_premium
      restaurant.subscription.should be_complimentary
    end
    
  end
  
end