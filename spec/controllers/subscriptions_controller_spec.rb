require 'spec_helper'

describe SubscriptionsController do

  describe "GET new" do
    
    before(:each) do
      @user = Factory(:user, :email => "fred@flintstone.com", :username => "fred")
      @controller.stubs(:current_user).returns(@user)
    end

    it "populates the tr data" do
      BraintreeConnector.any_instance.expects(:braintree_data => "data")
      get :new, :id => @user.id
      assigns[:tr_data].should == "data"
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
      assigns[:user].should == user
    end
    
    it "picks the right user if the user is an admin looking at another user" do
      @controller.stubs(:current_user).returns(admin)
      get :new, :id => user.id
      assigns[:user].should == user
    end
    
    it "blocks if a regular user tries to look at another user" do
      @controller.stubs(:current_user).returns(user)
      get :new, :id => admin.id
      response.should redirect_to(root_path)
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
      get :bt_callback, :id => @user.id
      response.should redirect_to(edit_user_path(@user))
    end

    it "does not update the user if braintree has problem" do
      BraintreeConnector.any_instance.expects(:confirm_request_and_start_subscription => stub(:success? => false))
      @user.expects(:make_premium!).never
      get :bt_callback, :id => @user.id
      response.should redirect_to(new_subscription_path(:id => @user.id))
    end
    
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @user = Factory(:user, :email => "fred@flintstone.com", 
          :username => "fred")
      @user.subscription = Factory(:subscription)
      @controller.stubs(:current_user).returns(@user)
    end
    
    it "removes the subscription on successful delete" do
      BraintreeConnector.any_instance.expects(
          :cancel_subscription).with(@user.subscription).returns(stub(:success? => true))
      delete :destroy, :id => @user.id
      @user.subscription.should be_nil
      @user.premium_account.should be_false
    end
    
  end

end
