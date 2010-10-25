require 'spec_helper'

describe BraintreeConnector do

  describe "with a user" do

    let(:user) { Factory(:user, :id => 500, 
        :subscription => Factory(:subscription, :braintree_id => "abcd"), 
        :email => "fred@flintstone.com") }
    let(:connector) { BraintreeConnector.new(user, "callback") }
    let(:stub_customer_request) { 
        stub(:customer => stub(:credit_cards => [stub(:token => "abcd")]),
          :success? => true) }

    it "creates a unique braintree customer id" do
      connector.braintree_customer_id.should == "User_#{user.id}"
    end

    it "derive the correct plan id" do
      connector.braintree_plan_id.should == "user_monthly"
    end

    it "should have a contact email" do
      connector.braintree_contact_email.should == user.email
    end

    it "calls braintree customer" do
      Braintree::Customer.expects(:find).with("User_#{user.id}")
      connector.braintree_customer
    end

    it "confirms a customer request" do
      query_string = "this_is_a_query_string"
      Braintree::TransparentRedirect.expects(:confirm).with(query_string)
      request = stub(:query_string => query_string)
      connector.confirm_request(request)
    end

    it "creates subscription requests" do
      connector.stubs(:confirm_request => stub_customer_request)
      Braintree::Subscription.expects(:create).with(
        :payment_method_token => "abcd", :plan_id => "user_monthly")
      connector.confirm_request_and_start_subscription(stub(:query_string => "query_string"))
    end

    it "returns update data if the customer exists" do
      connector.stubs(:braintree_customer => stub_customer_request.customer)
      Braintree::TransparentRedirect.expects(:update_customer_data).with(
          :redirect_url => "callback",
          :customer_id => "User_500",
          :customer => {
              :email => user.email,
              :credit_card => {
                :options => {
                  :update_existing_token => "abcd",
                  :verify_card => true
                }
              }
            }
          )
      connector.braintree_data
    end

    it "returns create data if the customer does not exist" do
      connector.stubs(:braintree_customer => nil)
      Braintree::TransparentRedirect.expects(:create_customer_data).with(
          :redirect_url => "callback",
          :customer => {
              :id => "User_500",
              :email => user.email,
              :credit_card => {
                :options => {
                  :verify_card => true
                }
              }
            }
          )
      connector.braintree_data
    end

    it "can delete a subscription" do
      Braintree::Subscription.expects(:cancel).with("abcd")
      connector.cancel_subscription(user.subscription)
    end
    
    it "finds a subscription when requested" do
      Braintree::Subscription.expects(:find).with("abcd")
      connector.find_subscription(Factory(:subscription))
    end

  end
  
  describe "with a restaurant" do
    
    let(:restaurant) { Factory(:managed_restaurant, :id => 500, 
        :subscription => Factory(:subscription, :braintree_id => "abcd"), 
        :manager => Factory(:user, :email => "fred@flintstone.com")) }
      
    let(:connector) { BraintreeConnector.new(restaurant, "callback") }
  
    let(:stub_customer_request) { 
        stub(:customer => stub(:credit_cards => [stub(:token => "abcd")]),
          :success? => true) }

    it "creates a unique braintree customer id" do
      connector.braintree_customer_id.should == "Restaurant_#{restaurant.id}"
    end

    it "derive the correct plan id" do
      connector.braintree_plan_id.should == "restaurant_monthly"
    end

    it "should have a contact email" do
      connector.braintree_contact_email.should == "fred@flintstone.com"
    end
  
    it "returns update data if the customer exists" do
      connector.stubs(:braintree_customer => stub_customer_request.customer)
      Braintree::TransparentRedirect.expects(:update_customer_data).with(
          :redirect_url => "callback",
          :customer_id => "Restaurant_500",
          :customer => {
              :email => "fred@flintstone.com",
              :credit_card => {
                :options => {
                  :update_existing_token => "abcd",
                  :verify_card => true
                }
              }
            }
          )
      connector.braintree_data
    end
  end

end