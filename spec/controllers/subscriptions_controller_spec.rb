require 'spec_helper'

describe SubscriptionsController do

  describe "GET new" do
    
    context "with a user" do

      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @controller.stubs(:current_user).returns(@user)
      end

      it "populates the tr data" do
        BraintreeConnector.any_instance.expects(:braintree_data => "data")
        get :new, :id => @user.id
        assigns[:braintree_customer].should == @user
        assigns[:tr_data].should == "data"
      end

    end    

    context "with a restaurant" do
      
      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @restaurant = Factory(:managed_restaurant, :manager => @user)
        @controller.stubs(:current_user).returns(@user)
      end

      it "populates the tr data" do
        BraintreeConnector.any_instance.expects(:braintree_data => "data")
        get :new, :id => @user.id, :subscriber_type => "restaurant"
        assigns[:braintree_customer].should == @restaurant
        assigns[:tr_data].should == "data"
      end
      
    end

  end

  describe "find user behavior" do

    let(:user) { Factory(:user) }
    let(:admin) { Factory(:admin) }

    before(:each) do
      BraintreeConnector.any_instance.stubs(:braintree_data => "data")
    end

    it "picks the right user if the current user is not an admin" do
      @controller.stubs(:current_user).returns(user)
      get :new, :id => user.id
      assigns[:braintree_customer].should == user
    end

    it "picks the right user if the user is an admin looking at another user" do
      @controller.stubs(:current_user).returns(admin)
      get :new, :id => user.id
      assigns[:braintree_customer].should == user
    end

    it "blocks if a regular user tries to look at another user" do
      @controller.stubs(:current_user).returns(user)
      get :new, :id => admin.id
      response.should redirect_to(root_path)
    end
  end

  describe "GET bt_callback" do
    
    describe "with a user" do
      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @controller.stubs(:current_user).returns(@user)
      end

      it "updates the user if everything is correct" do
        BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription => stub(:success? => true))
        @user.expects(:make_premium!)
        get :bt_callback, :customer_id => @user.id, :subscriber_type => :user
        response.should redirect_to(edit_user_path(@user))
      end

      it "does not update the user if braintree has problem" do
        BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription => stub(:success? => false))
        @user.expects(:make_premium!).never
        get :bt_callback, :customer_id => @user.id, :subscriber_type => :user
        response.should redirect_to(new_subscription_path(
            :customer_id => @user.id, :subscriber_type => "user"))
      end
    end
    
    describe "with a restaurant" do
      
      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @restaurant = Factory(:managed_restaurant, :manager => @user)
        @controller.stubs(:current_user).returns(@user)
        @controller.expects(:find_restaurant).returns(@restaurant)
      end
      
      it "updates the restaurant if everything is correct" do
        BraintreeConnector.any_instance.expects(
            :confirm_request_and_start_subscription => stub(:success? => true))
        @restaurant.expects(:make_premium!)
        get :bt_callback, :customer_id => @restaurant.id, 
            :subscriber_type => "restaurant"
        response.should redirect_to(edit_restaurant_url(@restaurant))
      end

      it "does not update the user if braintree has problem" do
        BraintreeConnector.any_instance.expects(
            :confirm_request_and_start_subscription => stub(:success? => false))
        @restaurant.expects(:make_premium!).never
        get :bt_callback, :customer_id => @restaurant.id, 
            :subscriber_type => "restaurant"
        response.should redirect_to(new_subscription_url(
            :customer_id => @restaurant.id, :subscriber_type => "restaurant"))
      end
      
      
    end

  end

  describe "DELETE destroy" do
    
    describe "with a user" do
      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com",
            :username => "fred")
        @user.subscription = Factory(:subscription, :payer => @user)
        @controller.stubs(:current_user).returns(@user)
      end

      it "puts the subscription in overtime on successful delete" do
        BraintreeConnector.expects(:find_subscription).with(
            @user.subscription).returns(
                stub(:billing_period_end_date => 1.month.from_now.to_date))
        BraintreeConnector.any_instance.expects(
            :cancel_subscription).with(@user.subscription).returns(stub(:success? => true))
        delete :destroy, :id => @user.id, :subscriber_type => "user"
        @user.subscription.should be_in_overtime
        @user.subscription.end_date.should == 1.month.from_now.to_date
        @user.should be_premium_account
        response.should redirect_to(edit_user_path(@user))
      end
      
      it "does not call braintree if the subscription is complimentary" do
        @user.subscription = Factory(:subscription, :payer => nil)
        BraintreeConnector.any_instance.expects(:cancel_subscription).never
        delete :destroy, :customer_id => @user.id, :subscriber_type => "user"
        @user.subscription.should be_in_overtime
      end
      
    end
    
    describe "with a restaurant" do
      
      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com",
            :username => "fred")
        @restaurant = Factory(:managed_restaurant, :manager => @user)
        @restaurant.subscription = Factory(:subscription, :payer => @restaurant)
        @controller.stubs(:current_user).returns(@user)
        @controller.expects(:find_restaurant).returns(@restaurant)
      end
      
      it "puts the subscription in overtime on successful delete" do
        BraintreeConnector.expects(:find_subscription).with(
            @restaurant.subscription).returns(
                stub(:billing_period_end_date => 1.month.from_now.to_date))
        BraintreeConnector.any_instance.expects(
            :cancel_subscription).with(@restaurant.subscription).returns(stub(:success? => true))
        delete :destroy, :customer_id => @restaurant.id, 
            :subscriber_type => "restaurant"
        @restaurant.subscription.should be_in_overtime
        @restaurant.subscription.end_date.should == 1.month.from_now.to_date
        @restaurant.should be_premium_account
        response.should redirect_to(edit_restaurant_path(@restaurant))
      end
      
    end

    

  end

end
