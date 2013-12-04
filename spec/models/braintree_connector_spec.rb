require_relative '../spec_helper'

describe BraintreeConnector do

  describe "with a user" do

    let(:user) { FactoryGirl.create(:user, :id => 500,
        :subscription => FactoryGirl.create(:subscription, :braintree_id => "abcd"),
        :email => "fred@flintstone.com") }
    let(:connector) { BraintreeConnector.new(user, "callback") }

    it "creates a unique braintree customer id" do
      connector.braintree_customer_id.should match /User_#{user.id}$/
    end

    it "derive the correct plan id" do
      connector.braintree_plan_id.should == "user_monthly"
    end

    it "calls braintree customer" do
      Braintree::Customer.expects(:find).with(BraintreeConnector.braintree_customer_id(user))
      connector.braintree_customer
    end

    it "confirms a customer request" do
      query_string = "this_is_a_query_string"
      Braintree::TransparentRedirect.expects(:confirm).with(query_string)
      request = stub(:query_string => query_string)
      connector.confirm_request(request)
    end

    it "creates subscription requests" do
      user.stubs(:subscription => nil)
      connector.stubs(:confirm_request => stub_customer_request)
      Braintree::Subscription.expects(:create).with(
        :payment_method_token => "abcd", :plan_id => "user_monthly")
      Braintree::Subscription.expects(:update).never
      connector.confirm_request_and_start_subscription(
          stub(:query_string => "query_string"), :apply_discount => false)
    end

    it "returns update data if the customer exists" do
      connector.stubs(:braintree_customer => stub_customer_request.customer)
      Braintree::TransparentRedirect.expects(:update_customer_data).with(
          :redirect_url => "callback",
          :customer_id => BraintreeConnector.braintree_customer_id(user),
          :customer => {
              :email => user.email,
              :first_name => user.first_name,
              :last_name => user.last_name,
              :company => "NA",
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
              :id => BraintreeConnector.braintree_customer_id(user),
              :email => user.email,
              :first_name => user.first_name,
              :last_name => user.last_name,
              :company => "NA",
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
      connector.find_subscription(FactoryGirl.create(:subscription))
    end

    describe "#billing_history" do
      it "should query braintree using the subscriber id" do
        fake_result = Object.new
        Braintree::Transaction.expects(:search).yields(stub(:customer_id)).returns(fake_result)
        result = connector.transaction_history
        result.should == fake_result
      end
    end

    it "updates customer information" do
      Braintree::Customer.expects(:update).with(
          BraintreeConnector.braintree_customer_id(user),
          has_entries(
              :first_name => user.first_name,
              :last_name => user.last_name,
              :email => user.email)).returns(stub(:success? => true))
      BraintreeConnector.update_customer(user)
    end

  end

  describe "with a restaurant" do

    let(:restaurant) { FactoryGirl.create(:restaurant, :id => 56,
        :subscription => FactoryGirl.create(:subscription, :braintree_id => "abcd"),
        :manager => FactoryGirl.create(:user, :email => "fred@flintstone.com")) }

    let(:connector) { BraintreeConnector.new(restaurant, "callback") }

    let(:stub_customer_request) {
        stub(:customer => stub(:credit_cards => [stub(:token => "abcd")]),
          :success? => true) }

    it "creates a unique braintree customer id" do
      connector.braintree_customer_id.should match /Restaurant_#{restaurant.id}$/
    end

    it "derives the correct plan id" do
      connector.braintree_plan_id.should == "restaurant_monthly"
    end

    it "returns update data if the customer exists" do
      connector.stubs(:braintree_customer => stub_customer_request.customer)
      Braintree::TransparentRedirect.expects(:update_customer_data).with(
          :redirect_url => "callback",
          :customer_id => BraintreeConnector.braintree_customer_id(restaurant),
          :customer => {
              :email => restaurant.manager.email,
              :first_name => restaurant.manager.first_name,
              :last_name => restaurant.manager.last_name,
              :company => restaurant.name,
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

    describe "create with a discount" do
      it "creates subscription requests" do
        restaurant.subscription.update_attributes(:payer => nil, :braintree_id => nil)
        connector.stubs(:confirm_request => stub_customer_request)
        Braintree::Subscription.expects(:create).with(
          :payment_method_token => "abcd",
          :plan_id => "restaurant_monthly",
          :discounts => {
              :add => [{:inherited_from_id => "complimentary_restaurant"}]})
        Braintree::Subscription.expects(:update).never
        connector.confirm_request_and_start_subscription(
            stub(:query_string => "query_string"), :apply_discount => true)
      end
    end

    it "updates restaurant information" do
      # Braintree::Customer.expects(:update).with(
      #     BraintreeConnector.braintree_customer_id(restaurant),
      #     has_entries(
      #         :first_name => restaurant.manager.first_name,
      #         :last_name => restaurant.manager.last_name,
      #         :email => restaurant.manager.email,
      #         :company => restaurant.name)).returns(stub(:success? => true))
      BraintreeConnector.update_customer(restaurant)
    end

  end

  it "requires payer to implement braintree_contact" do
    lambda { BraintreeConnector.new(Object.new, "callback") }.should raise_error(NotImplementedError)
  end

  describe "#past_due_subscriptions" do
    it "returns a list of past due braintree_subscription_ids" do
      Braintree::Subscription.expects(:search).yields(stub(:days_past_due)).returns(stub(:ids => [1, 2, 3]))
      result = BraintreeConnector.past_due_subscriptions
      result.should == [1, 2, 3]
    end
  end

  describe "add on to subscription" do

    let(:restaurant) { FactoryGirl.create(:restaurant) }
    let(:subscription) { FactoryGirl.create(:subscription,
        :payer => restaurant, :subscriber => restaurant) }

    it "calls add if the quantity is one" do
      Braintree::Subscription.expects(:update).with("abcd", :add_ons => {:add => [{
              :inherited_from_id => "user_for_restaurant",
              :quantity => 1}]})
      BraintreeConnector.set_add_ons_for_subscription(subscription, 1)
    end

    it "calls update if the quantity is greater than one" do
      FactoryGirl.create(:subscription, :payer => restaurant, :subscriber => FactoryGirl.create(:user))
      Braintree::Subscription.expects(:update).with("abcd", :add_ons => {:update => [{
              :existing_id => "user_for_restaurant",
              :quantity => 2}]})
      BraintreeConnector.set_add_ons_for_subscription(subscription, 2)
    end

    it "calls update if the quantity is decremented to one" do
      FactoryGirl.create(:subscription, :payer => restaurant, :subscriber => FactoryGirl.create(:user))
      FactoryGirl.create(:subscription, :payer => restaurant, :subscriber => FactoryGirl.create(:user))
      Braintree::Subscription.expects(:update).with("abcd", :add_ons => {:update => [{
              :existing_id => "user_for_restaurant",
              :quantity => 1}]})
      BraintreeConnector.set_add_ons_for_subscription(subscription, 1)
    end

    it "calls remove if the quantity is zero" do
      FactoryGirl.create(:subscription, :payer => restaurant, :subscriber => FactoryGirl.create(:user))
      Braintree::Subscription.expects(:update).with("abcd",
          :add_ons => {:remove => ["user_for_restaurant"]})
      BraintreeConnector.set_add_ons_for_subscription(subscription, 0)
    end

  end

  describe "add discount to subscription" do

    let(:subscription) { FactoryGirl.create(:subscription) }

    it "calls the braintree subscription for creating a discount" do
      Braintree::Subscription.expects(:update).with("abcd",
          :discounts => {:add => [{:inherited_from_id => "complimentary_restaurant"}]})
      BraintreeConnector.update_subscription_with_discount(subscription)
    end

  end


end