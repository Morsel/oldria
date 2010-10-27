require 'spec/spec_helper'

describe EmployeeAccountsController do
  
  describe "POST create" do
    
    describe "with a premium account and a basic user" do
      let(:user) { Factory(:user) }
      let(:restaurant) { Factory(:managed_restaurant, :manager => :user) }
      let(:employee) { Factory(:user) }
      
      before(:each) do
        restaurant.subscription = Factory(:subscription)
        restaurant.save!
        controller.stubs(:current_user).returns(user)
        restaurant.employees << employee
        post :create
      end
      
      it "should create the add on to braintree" do
        
      end
      
      it "should create the correct user account" do
        
      end
    end
    
    desc "with a premium account an existing add on, and a basic user" do
      
    end
    
  end
  
end