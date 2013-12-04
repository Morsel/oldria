require_relative '../spec_helper'

describe EmployeeAccountsController do
  
  describe "POST create" do
    
    let(:user) { Factory(:user) }
    let(:restaurant) { Factory(:restaurant, :manager => user) }
    let(:employee) { Factory(:user) }
    
    before(:each) do
      restaurant.subscription = Factory(:subscription, :payer => restaurant)
      controller.stubs(:current_user).returns(user)
      restaurant.employees << employee
      restaurant.save!
    end
    
    describe "with a premium account and a basic user" do
      
      before(:each) do
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(
            restaurant.subscription, 1).returns(stub(:success? => true))
        post :create, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "should create the correct user account" do
        restaurant.should have(2).paid_subscriptions
        user.subscription.should be_staff_account
      end
      
      it "redirects back to the employee edit page" do
        flash[:error].should be_nil
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
    end
    
    describe "with a premium account and a premium user" do
      let(:bt_sub) { stub(:subscription => stub(:id => "abcd")) }
      
      before(:each) do
        user.make_premium!(bt_sub)
        user.subscription.update_attributes(:start_date => 1.month.ago.to_date)
        BraintreeConnector.expects(:cancel_subscription).with(user.subscription)
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(
            restaurant.subscription, 1).returns(stub(:success? => true))
        post :create, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "should create the correct user account" do
        restaurant.should have(2).paid_subscriptions
        user.reload
        user.subscription.should be_staff_account
        user.subscription.start_date.should == 1.month.ago.to_date
        user.subscription.braintree_id.should be_nil
      end
      
      it "redirects back to the employee edit page" do
        flash[:error].should be_blank
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
    end
    
    describe "with a complimentary account and a basic user" do
      before(:each) do
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        restaurant.subscription.update_attributes(:payer => nil, :braintree_id => nil)
        post :create, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "shows the credit card from" do
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
    end
    
    describe "with a braintree failure" do
      
      before(:each) do
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(
            restaurant.subscription, 1).returns(stub(:success? => false))
        post :create, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "does not create a user account" do
        restaurant.should have(1).paid_subscription
        user.subscription.should be_nil
      end
      
      it "redirects back to the employee page" do
        flash[:error].should_not be_nil
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
      
    end
    
    describe "with a security failure" do
      
      before(:each) do
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        post :create, :restaurant_id => restaurant.id, :id => Factory(:user).id
      end
      
      it "does not create a user account" do
        restaurant.should have(1).paid_subscription
        user.subscription.should be_nil
      end
      
      it "redirects back to the employee page" do
        flash[:error].should_not be_nil
        response.should redirect_to(root_url)
      end
      
    end
    
    describe "if the restaurant doesn't have a premium account" do
      
      before(:each) do
        Subscription.delete_all
        restaurant.update_attributes(:subscription => nil)
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        post :create, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "does not create a user account" do
        restaurant.should have(:no).paid_subscriptions
        user.subscription.should be_nil
      end
      
      it "redirects back to the employee page" do
        flash[:error].should_not be_nil
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
      
    end
    
  end
  
  describe "DELETE destroy" do
    
    let(:user) { Factory(:user) }
    let(:restaurant) { Factory(:restaurant, :manager => user) }
    let(:employee) { Factory(:user) }
    
    before(:each) do
      restaurant.subscription = Factory(:subscription, :payer => restaurant)
      controller.stubs(:current_user).returns(user)
      restaurant.employees << employee
      restaurant.save!
    end
    
    describe "cancel an user account for a restaurant with more than two accounts" do
      
      before(:each) do
        user.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant))
        user2 = Factory(:user)
        user2.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant))
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(
            restaurant.subscription, 1).returns(stub(:success? => true))
        delete :destroy, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "should create the correct user account" do
        restaurant.subscription.should have(1).user_subscriptions_for_payer
        user.reload.subscription.should be_nil
      end
      
      it "redirects back to the employee edit page" do
        flash[:error].should be_nil
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
      
    end
    
    describe "with a braintree failure" do
      
      before(:each) do
        user.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant))
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(
            restaurant.subscription, 0).returns(stub(:success? => false))
        delete :destroy, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "does not remove a user account" do
        restaurant.should have(2).paid_subscriptions
        user.subscription.should be_staff_account
        flash[:error].should_not be_nil
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
      
    end
    
    describe "with a security failure" do
      
      before(:each) do
        user.update_attributes(:subscription => Factory(:subscription,
            :payer => restaurant))
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        delete :destroy, :restaurant_id => restaurant.id, :id => Factory(:user).id
      end
      
      it "does not create a user account" do
        restaurant.should have(2).paid_subscription
        user.subscription.should be_staff_account
        flash[:error].should_not be_nil
        response.should redirect_to(root_url)
      end
      
    end
    
    describe "if the restaurant doesn't have a premium account" do
      
      before(:each) do
        Subscription.delete_all
        restaurant.update_attributes(:subscription => nil)
        BraintreeConnector.expects(:set_add_ons_for_subscription).never
        delete :destroy, :restaurant_id => restaurant.id, :id => user.id
      end
      
      it "does not create a user account" do
        restaurant.should have(:no).paid_subscriptions
        user.subscription.should be_nil
        flash[:error].should_not be_nil
        response.should redirect_to(edit_restaurant_employee_path(restaurant, user))
      end
      
    end
    
  end
  
end