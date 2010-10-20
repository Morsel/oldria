require 'spec_helper'

describe SubscriptionsController do

  describe "GET new" do

    it "populates the tr data" do
      BraintreeConnector.any_instance.expects(:braintree_data => "data")
      get :new
      assigns[:tr_data].should == "data"
    end

  end

  describe "GET bt_callback" do

    before(:each) do
      @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
      @controller.stubs(:current_user).returns(@user)
    end

    it "updates the user if everything is correct" do
      BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription => stub(:success? => true))
      @user.expects(:make_premium!)
      get :bt_callback
      response.should redirect_to(edit_user_path(@user))
    end

    it "does not upate the user if braintree has problesm" do
      BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription => stub(:success? => false))
      @user.expects(:make_premium!).never
      get :bt_callback
      response.should redirect_to(new_subscription_path)
    end
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @user = Factory(:user, :email => "fred@flintstone.com", 
          :username => "fred", :premium_account => true)
      @user.subscription = Factory(:subscription)
      @controller.stubs(:current_user).returns(@user)
    end
    
    it "removes the subscription on successful delete" do
      BraintreeConnector.any_instance.expects(
          :cancel_subscription).with(@user.subscription).returns(stub(:success? => true))
      delete :destroy, :id => @user.subscription.id
      @user.subscription.should be_nil
      @user.premium_account.should be_false
    end
    
  end

end
