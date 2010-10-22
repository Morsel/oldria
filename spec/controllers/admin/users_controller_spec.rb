require 'spec_helper'

describe Admin::UsersController do
  
  before(:each) do
    @admin = Factory.stub(:admin)
    controller.stubs(:current_user).returns(@admin)
    controller.stubs(:require_admin).returns(true)
  end
  
  describe "POST make_complimentary" do
    
    let(:user) { Factory(:user) }
    
    it "gives a basic user a complimentary account" do
      user.cancel_subscription
      User.stubs(:find).returns(user)
      user.expects(:make_complimentary!)
      BraintreeConnector.expects(:cancel_subscription).never
      post :make_complimentary, :id => user.id
      response.should redirect_to(edit_admin_user_path(user))
    end
    
    it "cancels the braintree subscription if it exists" do
      user.subscription = Factory(:subscription, :payer => user)
      user.save!
      User.stubs(:find).returns(user)
      user.expects(:make_complimentary!)
      BraintreeConnector.expects(
          :cancel_subscription).returns(stub(:success? => true))
      post :make_complimentary, :id => user.id
      response.should redirect_to(edit_admin_user_path(user))
    end
    
  end
  
  describe "POST cancel_complimentary" do
    
    let(:user) { Factory(:user) }
    
    it "removes a complimentary account" do
      user.make_complimentary!
      User.stubs(:find).returns(user)
      user.expects(:cancel_subscription)
      BraintreeConnector.expects(:cancel_subscription).never
      post :cancel_complimentary, :id => user.id
      response.should redirect_to(edit_admin_user_path(user))
    end
    
    it "cancels the braintree account when canceling a regular account" do
      user.subscription = Factory(:subscription, :payer => user)
      user.save!
      User.stubs(:find).returns(user)
      user.expects(:cancel_subscription)
      BraintreeConnector.expects(
          :cancel_subscription).returns(stub(:success? => true))
      post :cancel_complimentary, :id => user.id
    end
    
  end
  
end