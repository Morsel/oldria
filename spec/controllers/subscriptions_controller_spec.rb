require_relative '../spec_helper'

describe SubscriptionsController do

  describe "GET new" do

    context "with a user" do

      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @controller.stubs(:current_user).returns(@user)
      end

      it "populates the tr data" do
        BraintreeConnector.any_instance.expects(:braintree_data => "data")
        get :new, :user_id => @user.id
        assigns[:braintree_customer].should == @user
        assigns[:tr_data].should == "data"
      end

    end

    context "with a restaurant" do

      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @restaurant = Factory(:restaurant, :manager => @user)
        @controller.stubs(:current_user).returns(@user)
      end

      it "populates the tr data" do
        BraintreeConnector.any_instance.expects(:braintree_data => "data")
        get :new, :restaurant_id => @restaurant.id
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
      get :new, :user_id => user.id
      assigns[:braintree_customer].should == user
    end

    it "picks the right user if the user is an admin looking at another user" do
      @controller.stubs(:current_user).returns(admin)
      get :new, :user_id => user.id
      assigns[:braintree_customer].should == user
    end

    it "blocks if a regular user tries to look at another user" do
      @controller.stubs(:current_user).returns(user)
      get :new, :user_id => admin.id
      response.should redirect_to(root_path)
    end
  end

  describe "GET bt_callback" do

    describe "with a user" do
      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @controller.stubs(:current_user).returns(@user)
      end

      it "makes the user premium if everything is correct" do
        BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription).with(
            anything, {:apply_discount => false}).returns(stub(:success? => true))
        @user.expects(:make_premium!)
        get :bt_callback, :user_id => @user.id, :kind => 'create_customer'
        response.should redirect_to(edit_user_path(@user))
      end

      it "does not make the user premium if braintree has problem" do
        BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription => stub(:success? => false, :message => "message"))
        @user.expects(:make_premium!).never
        get :bt_callback, :user_id => @user.id, :kind => 'create_customer'
        response.should redirect_to(new_user_subscription_path(@user))
      end

      it "updates the user subscription if everything is correct" do
        BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription).with(
            anything, {:apply_discount => false}).returns(stub(:success? => true))
        @user.expects(:update_premium!)
        get :bt_callback, :user_id => @user.id, :kind => 'update_customer'
        response.should redirect_to(edit_user_path(@user))
      end

      it "does not udate the user's subscription if braintree has problem" do
        BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription => stub(:success? => false, :message => "message"))
        @user.expects(:update_premium!).never
        get :bt_callback, :user_id => @user.id, :kind => 'update_customer'
        response.should redirect_to(edit_user_subscription_path(@user))
      end
    end

    describe "with a restaurant" do

      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @restaurant = Factory(:restaurant, :manager => @user)
        @controller.stubs(:current_user).returns(@user)
        @controller.expects(:find_restaurant).returns(@restaurant)
      end

      it "makes the restaurant premium if everything is correct" do
        BraintreeConnector.any_instance.expects(
            :confirm_request_and_start_subscription).with(
                anything, {:apply_discount => false}).returns(stub(:success? => true))
        @restaurant.expects(:make_premium!)
        get :bt_callback, :restaurant_id => @restaurant.id, :kind => 'create_customer'
        response.should redirect_to(edit_restaurant_url(@restaurant))
      end

      it "does not make the restaurant premium if braintree has problem" do
        BraintreeConnector.any_instance.expects(
            :confirm_request_and_start_subscription => stub(:success? => false, :message => "message"))
        @restaurant.expects(:make_premium!).never
        get :bt_callback, :restaurant_id => @restaurant.id, :kind => 'create_customer'
        response.should redirect_to(new_restaurant_subscription_path(@restaurant))
      end

      it "updates the restaurant subscription if everything is correct" do
        BraintreeConnector.any_instance.expects(
            :confirm_request_and_start_subscription).with(
                anything, {:apply_discount => false}).returns(stub(:success? => true))
        @restaurant.expects(:update_premium!)
        get :bt_callback, :restaurant_id => @restaurant.id, :kind => 'update_customer'
        response.should redirect_to(edit_restaurant_url(@restaurant))
      end

      it "does not update the restaurant subscription if braintree has problem" do
        BraintreeConnector.any_instance.expects(
            :confirm_request_and_start_subscription => stub(:success? => false, :message => "message"))
        @restaurant.expects(:update_premium!).never
        get :bt_callback, :restaurant_id => @restaurant.id, :kind => 'update_customer'
        response.should redirect_to(edit_restaurant_subscription_path(@restaurant))
      end
    end

    describe "with a complimentary restaurant" do

      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
        @restaurant = Factory(:restaurant, :manager => @user)
        @restaurant.update_attributes(:subscription =>
            Factory(:subscription, :payer => nil, :braintree_id => nil))
        @controller.stubs(:current_user).returns(@user)
        @controller.expects(:find_restaurant).returns(@restaurant)
      end

      it "updates the restaurant if everything is correct" do
        BraintreeConnector.any_instance.expects(
            :confirm_request_and_start_subscription).with(
            anything, {:apply_discount => true}).returns(stub(:success? => true,
            :subscription => stub(:id => "abcd")))
        @restaurant.expects(:update_complimentary_with_braintree_id!).with("abcd")
        get :bt_callback, :restaurant_id => @restaurant.id
        response.should redirect_to(edit_restaurant_url(@restaurant))
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
        delete :destroy, :user_id => @user.id
        @user.subscription.should be_in_overtime
        @user.subscription.end_date.should == 1.month.from_now.to_date
        @user.should be_premium_account
        response.should redirect_to(edit_user_path(@user))
      end

      it "does not call braintree if the subscription is complimentary" do
        @user.subscription = Factory(:subscription, :payer => nil, :braintree_id => nil)
        BraintreeConnector.any_instance.expects(:cancel_subscription).never
        delete :destroy, :user_id => @user.id
        @user.subscription.should be_in_overtime
      end

    end

    describe "with a restaurant" do

      before(:each) do
        @user = Factory(:user, :email => "fred@flintstone.com",
            :username => "fred")
        @restaurant = Factory(:restaurant, :manager => @user)
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
        delete :destroy, :restaurant_id => @restaurant.id
        @restaurant.subscription.should be_in_overtime
        @restaurant.subscription.end_date.should == 1.month.from_now.to_date
        @restaurant.should be_premium_account
        response.should redirect_to(edit_restaurant_path(@restaurant))
      end

      it "puts staff subscriptions in overtime on successful delete" do
        @user.update_attributes(:subscription => Factory(:subscription,
            :payer => @restaurant))
        BraintreeConnector.expects(:find_subscription).with(
            @restaurant.subscription).returns(
                stub(:billing_period_end_date => 2.weeks.from_now.to_date))
        BraintreeConnector.any_instance.expects(
            :cancel_subscription).with(@restaurant.subscription).returns(stub(:success? => true))
        delete :destroy, :restaurant_id => @restaurant.id
        @user.reload.subscription.should be_in_overtime
        @user.reload.subscription.end_date.should == 2.weeks.from_now.to_date
        @user.reload.should be_premium_account
      end

    end
  end
end
