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
      post :cancel_complimentary, :id => user.id
      response.should redirect_to(edit_admin_user_path(user))
    end
    
  end
  
end