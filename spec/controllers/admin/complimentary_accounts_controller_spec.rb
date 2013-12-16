require_relative '../../spec_helper'

describe Admin::ComplimentaryAccountsController do
  
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    controller.stubs(:current_user).returns(@admin)
    controller.stubs(:require_admin).returns(true)
  end
  
  describe "POST create" do
    
    describe "with a user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:restaurant) { FactoryGirl.create(:restaurant) }

      it "gives a basic user a complimentary account" do
        user.cancel_subscription!(:terminate_immediately => true)
        User.stubs(:find).returns(user)
        user.expects(:make_complimentary!)
        BraintreeConnector.expects(:cancel_subscription).never
        post :create, :subscriber_id => user.id, :subscriber_type => "user"
        response.should redirect_to(edit_admin_user_path(user))
      end

      it "cancels the braintree subscription if it exists" do
        user.subscription = FactoryGirl.create(:subscription, :payer => user)
        user.save!
        User.stubs(:find).returns(user)
        BraintreeConnector.expects(:update_subscription_with_discount).never
        BraintreeConnector.expects(
            :cancel_subscription).returns(stub(:success? => true))
        post :create, :subscriber_id => user.id, :subscriber_type => "user"
        response.should redirect_to(edit_admin_user_path(user))
      end
      
      it "updates the restaurant account if the user is a staff account" do
        restaurant.subscription = FactoryGirl.create(:subscription, :payer => restaurant)
        restaurant.save!
        user.subscription = FactoryGirl.create(:subscription, :payer => restaurant, 
            :braintree_id => nil)
        user.save!
        User.stubs(:find).returns(user)
        BraintreeConnector.expects(:update_subscription_with_discount).never
        BraintreeConnector.expects(:cancel_subscription).never
        BraintreeConnector.expects(:set_add_ons_for_subscription).with(
            restaurant.subscription, 0).returns(stub(:success? => true))
        post :create, :subscriber_id => user.id, :subscriber_type => "user"
        response.should redirect_to(edit_admin_user_path(user))
      end
    end
    
    describe "with a restaurant" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }
      
      it "gives a basic restaurant a complimentary account" do
        restaurant.cancel_subscription!(:terminate_immediately => true)
        Restaurant.stubs(:find).returns(restaurant)
        BraintreeConnector.expects(:cancel_subscription).never
        BraintreeConnector.expects(:update_subscription_with_discount).never
        post :create, :subscriber_id => restaurant.id, :subscriber_type => "restaurant"
        response.should redirect_to(edit_admin_restaurant_url(restaurant))
      end

      it "adds a discount to the braintree subscription if it exists" do
        restaurant.subscription = FactoryGirl.create(:subscription, :payer => restaurant)
        restaurant.save!
        user = FactoryGirl.create(:user)
        user.make_staff_account!(restaurant)
        Restaurant.stubs(:find).returns(restaurant)
        BraintreeConnector.expects(:cancel_subscription).never
        BraintreeConnector.expects(:update_subscription_with_discount).returns(
            stub(:success? => true))
        post :create, :subscriber_id => restaurant.id, :subscriber_type => "restaurant"
        response.should redirect_to(edit_admin_restaurant_url(restaurant))
      end
      
      it "cancels the account if the restaurant has no staff accounts" do
        restaurant.subscription = FactoryGirl.create(:subscription, :payer => restaurant)
        restaurant.save!
        BraintreeConnector.expects(:cancel_subscription).returns(stub(:success? => true))
        BraintreeConnector.expects(:update_subscription_with_discount).never
        post :create, :subscriber_id => restaurant.id, :subscriber_type => "restaurant"
        response.should redirect_to(edit_admin_restaurant_url(restaurant))
      end
      
      
    end
  end
  
  describe "DELETE destroy" do
    
    describe "with a user" do
      let(:user) { FactoryGirl.create(:user) }

      it "removes a complimentary account" do
        user.make_complimentary!
        User.stubs(:find).returns(user)
        user.expects(:admin_cancel)
        BraintreeConnector.expects(:cancel_subscription).never
        delete :destroy, :subscriber_id => user.id, :subscriber_type => "user"
        response.should redirect_to(edit_admin_user_path(user))
      end

      it "cancels the braintree account when canceling a regular account" do
        user.subscription = FactoryGirl.create(:subscription, :payer => user)
        user.save!
        User.stubs(:find).returns(user)
        BraintreeConnector.expects(:cancel_subscription).returns(stub(:success? => true))
        delete :destroy, :subscriber_id => user.id, :subscriber_type => "user"
      end
    end
    
    describe "with a restaurant" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }

      it "removes a complimentary account" do
        restaurant.make_complimentary!
        Restaurant.stubs(:find).returns(restaurant)
        restaurant.expects(:admin_cancel)
        BraintreeConnector.expects(:cancel_subscription).never
        delete :destroy, :subscriber_id => restaurant.id, :subscriber_type => "restaurant"
        response.should redirect_to(edit_admin_restaurant_path(restaurant))
      end

      it "cancels the braintree account when canceling a regular account" do
        restaurant.subscription = FactoryGirl.create(:subscription, :payer => restaurant)
        restaurant.save!
        Restaurant.stubs(:find).returns(restaurant)
        BraintreeConnector.expects(
            :cancel_subscription).returns(stub(:success? => true))
        delete :destroy, :subscriber_id => restaurant.id, :subscriber_type => "restaurant"
      end
    end
    
    
    
  end
  
end