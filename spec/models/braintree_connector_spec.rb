require 'spec_helper'

describe BraintreeConnector do

  describe "with a user" do

    let(:user) { stub(:id => 500) }
    let(:connector) { BraintreeConnector.new(user, "callback") }
    let(:stub_customer_request) { stub(:customer => stub(:credit_cards => [stub(:token => "abcd")]),
          :success? => true) }

    it "creates a unique braintree customer id" do
      connector.braintree_customer_id.should == "User_500"
    end

    it "calls braintree customer" do
      Braintree::Customer.expects(:find).with("User_500")
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
        :payment_method_token => "abcd", :plan_id => "kpw2")
      connector.confirm_request_and_start_subscription(stub(:query_string => "query_string"))
    end

    it "returns update data if the customer exists" do
      connector.stubs(:braintree_customer => stub_customer_request.customer)
      Braintree::TransparentRedirect.expects(:update_customer_data).with(
          :redirect_url => "callback",
          :customer_id => "User_500",
          :customer => {
              :credit_card => {
                :options => {
                  :update_existing_token => "abcd"
                }
              }
            }
          )
      connector.braintree_data
    end

    it "returns create data if the customer does not exist" do
      connector.stubs(:braintree_customer => nil)
      Braintree::TransparentRedirect.expects(:create_customer_data).with(
        :redirect_url => "callback", :customer => {:id => "User_500"})
      connector.braintree_data
    end

  end

end