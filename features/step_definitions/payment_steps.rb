include SubscriptionsControllerHelper

Then /^I see my account status is not premium$/ do
  #page.should have_selector(".current", :text => "Basic")
end

Then /^I see that the restaurant's account status is basic$/ do
  #page.should have_selector(".account", :text => "Basic")
end

Then /^I see that the restaurant's account status is premium$/ do
  #page.should have_selector(".account", :text => "Premium")
end

Then /^I do not see a premium badge$/ do
  page.should_not have_css(".premium_badge")
end

Then /^I see a link to update my account to premium$/ do
  #page.should have_selector("#upgrade_link a", :text => "Upgrade to Premium")
end

Given /^user "([^"]*)" has a premium account$/ do |username|
  user = User.find_by_username(username)
  user.make_premium!(stub(:subscription => stub(:id => "abcd")))
end

Given /^user "([^"]*)" does not have a premium account$/ do |username|
  user = User.find_by_username(username)
  user.subscription = nil
  user.save!
end

Given /^user "([^"]*)" has a complimentary premium account$/ do |name|
  user = User.find_by_username(name)
  user.make_complimentary!
end

Given /^user "([^"]*)" has a staff account for the restaurant "([^"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  user.make_staff_account!(restaurant)
end

Given /^the restaurant "([^"]*)" has a complimentary premium account$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  #restaurant.make_complimentary!
end

Given /^I simulate a successful account creation with discount from Braintree$/ do
  #pending # express the regexp above with the code you wish you had
end


Then /^I see a premium badge$/ do
  page.should have_css(".premium_badge")
end

Then /^I see my account status is premium$/ do
  #page.should have_selector(".current", :text => "Premium")
end

Then /^I see my account status is basic$/ do
  #page.should have_selector(".current", :text => "Basic")
end

Then /^I see my account status is a premium staff account$/ do
  #page.should have_selector(".current", :text => "Premium Staff")
end

Then /^I see my account status is complimentary$/ do
  #page.should have_selector(".current", :text => "Premium")
end


Then /^I see a link to cancel my account$/ do
  #page.should have_selector("#upgrade_link a", :text => "Downgrade to basic")
end

When /^I simulate braintree create behavior$/ do
  #BraintreeConnector.any_instance.stubs(:braintree_customer => nil)
end

When /^I simulate braintree update behavior$/ do
  @credit_card = {
    :last_4 => "1111",
    :expiration_month => "05",
    :expiration_year => "2015",
    :billing_address => {
      :postal_code => "11111"
    }
  }
  # BraintreeConnector.any_instance.stubs(
  #     :braintree_customer => stub(
  #       :kind => 'update_customer',
  #       :credit_cards => [
  #         stub(
  #           :token => "token_abcd",
  #           :last_4 => @credit_card[:last_4],
  #           :expiration_month => @credit_card[:expiration_month],
  #           :expiration_year => @credit_card[:expiration_year],
  #           :billing_address => stub(
  #             :postal_code => @credit_card[:billing_address][:postal_code]
  #           )
  #         )
  #       ]
  #     )
  #   )
end

When /^I simulate a successful call from braintree for user "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  # BraintreeConnector.any_instance.stubs(
  #     :confirm_request_and_start_subscription => stub(:success? => true,
  #         :subscription => stub(:id => "abcd")))
  # visit(bt_callback_subscription_url(user))
end

When /^I simulate a successful call from braintree for the restaurant "([^\"]*)"$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  # BraintreeConnector.any_instance.stubs(
  #     :braintree_customer => nil)
  # BraintreeConnector.any_instance.stubs(
  #     :confirm_request_and_start_subscription => stub(:success? => true,
  #         :subscription => stub(:id => "abcd")))
  # visit(bt_callback_subscription_url(restaurant))
end

When /^I simulate an unsuccessful call from braintree for user "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  # BraintreeConnector.any_instance.stubs(
  #     :braintree_customer => nil)
  # BraintreeConnector.any_instance.stubs(
  #     :confirm_request_and_start_subscription => stub(:success? => false, :message => "message"))
  # visit(bt_callback_subscription_url(user))
end

When /^I simulate an unsuccessful call from braintree for the restaurant "([^"]*)"$/ do |name|
  # restaurant = Restaurant.find_by_name(name)
  # BraintreeConnector.any_instance.stubs(
  #     :braintree_customer => nil)
  # BraintreeConnector.any_instance.stubs(
  #     :confirm_request_and_start_subscription => stub(:success? => false, :message => "message"))
  # visit(bt_callback_subscription_url(restaurant))
end

When /^I simulate a successful cancel from braintree$/ do
  # BraintreeConnector.any_instance.stubs(
  #     :cancel_subscription => stub(:success? => true))
  # BraintreeConnector.stubs(:find_subscription).returns(
  #         stub(:billing_period_end_date => 1.month.from_now.to_date))
end

When /^I simulate a required successful cancel from braintree$/ do
 # BraintreeConnector.expects(:cancel_subscription => stub(:success? => true))
  #BraintreeConnector.stubs(:find_subscription).returns(stub(:billing_period_end_date => 1.month.from_now.to_date))
end

When /^I simulate an unsuccessful cancel from braintree$/ do
  #BraintreeConnector.any_instance.stubs(:cancel_subscription => stub(:success? => false))
end

Then /^I see my account is paid for by myself$/ do
  page.should_not have_selector(".current", :text => "Complimentary")
  #page.should have_selector("#start_date", :text => "since #{Date.today.to_s(:long)}")
end

Then /^I see my restaurant account is paid for by myself$/ do
  page.should_not have_selector(".current", :text => "Complimentary")
  #page.should have_selector("#start_date", :text => "since #{Date.today.to_s(:long)}")
end

When /^I traverse the delete link for subscriptions for user "([^"]*)"$/ do |username|
  #visit(user_subscription_path(User.find_by_username(username).id, :method => :delete))
end

When /^I traverse the delete link for subscriptions for the restaurant "([^"]*)"$/ do |name|
  #visit(restaurant_subscription_path(Restaurant.find_by_name(name), :method => :delete))
end

Then /^I see that the account for "([^"]*)" lasts until the end of the billing cycle$/ do |username|
  user = User.find_by_username(username)
  # within "#end_date" do
  #   page.should have_content(user.subscription.end_date.to_s(:long).gsub(/\s+/, " "))
  # end
end

Then /^I see that the restaurant account for "([^"]*)" lasts until the end of the billing cycle$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  #page.should have_css("fieldset.account .alert", :text => restaurant.subscription.end_date.to_s(:long).gsub(/\s+/, " "))
end

Then /^I don't see that the account for "([^"]*)" lasts until the end of the billing cycle$/ do |username|
  #page.should_not have_css("#end_date")
end

Then /^I don't see that the restaurant account for "([^"]*)" lasts until the end of the billing cycle$/ do |arg1|
  #page.should_not have_css("fieldset.account .alert")
end

Then /^I do not see any account change options$/ do
  #page.should_not have_css("#upgrade_link")
end

Given /^the restaurant "([^"]*)" has a premium account$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.make_premium!(stub(:subscription => stub(:id => "abcd")))
 # BraintreeConnector.stubs(:cancel_subscription).with(
      #restaurant.subscription).returns(stub(:success? => true))
end

Given /^the restaurant "([^"]*)" has an overtime account$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.make_premium!(stub(:subscription => stub(:id => "abcd")))
  restaurant.subscription.update_attributes(:end_date => 1.month.from_now)
  # The cancel subscription call should never be made
  #BraintreeConnector.stubs(:cancel_subscription).never
end

Given /^the restaurant "([^"]*)" does not have a premium account$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.subscription = nil
  restaurant.save!
end

Given /^I simulate braintree search billing history behavior with the following:$/ do |table|
  @transactions = []
  table.hashes.each do |row|
    @transactions << stub(
            :id => row['transaction_id'],
            :amount => row['amount'],
            :status => row['status'],
            :created_at => eval(row['date']),
            :credit_card_details => stub(
                :last_4 => row['card_number'],
                :card_type => row['card_type'],
                :expiration_date => row['expiration_date']
            ),
            :class => Braintree::Transaction
          )
    # we are simulating a collection of the following braintree transaction objects
    # <Braintree::Transaction id: "bssvmm", type: "sale", amount: "250.0", status: "submitted_for_settlement", created_at: Wed Oct 27 14:25:10 UTC 2010, credit_card_details: #<token: "5bgy", bin: "411111", last_4: "1111", card_type: "Visa", expiration_date: "01/2011", cardholder_name: "", customer_location: "US">, customer_details: #<id: "Restaurant_35", first_name: nil, last_name: nil, email: "sonia@neotericdesign.com", company: nil, website: nil, phone: nil, fax: nil>, updated_at: Wed Oct 27 14:25:11 UTC 2010>
  end
  #BraintreeConnector.any_instance.stubs(:transaction_history => @transactions)
end

Then /^I should see all of my transaction details$/ do
  #page.should have_css("table#transactions")
  @transactions.each do |transaction|
    # page.should have_css("tr##{dom_id(transaction)}") do |trans_block|
    #   trans_block.should have_css("td", :text => transaction.id)
    #   trans_block.should have_css("td", :text => transaction.amount)
    #   trans_block.should have_css("td", :text => transaction.status)
    #   trans_block.should have_css("td", :text => transaction.created_at.strftime("%m/%d/%Y"))
    #   trans_block.should have_css("td", :text => transaction.credit_card_details.last_4)
    #   trans_block.should have_css("td", :text => transaction.credit_card_details.card_type)
    #   trans_block.should have_css("td", :text => transaction.credit_card_details.expiration_date)
    # end
  end
end

Then /^I see that "([^"]*)" has a basic account$/ do |username|
  user = User.find_by_username(username)
  # within ".account_status" do
  #   page.should have_content("Basic")
  # end
end

Then /^I see that "([^"]*)" has a premium account paid for by the restaurant$/ do |username|
  user = User.find_by_username(username)
  # within ".account_status" do
  #   page.should have_content("Premium Staff Account")
  #   page.should_not have_content("This account is paid for by a different restaurant.")
  # end
end

Then /^I see that "([^"]*)" does not have a premium account paid for by the restaurant$/ do |username|
  user = User.find_by_username(username)
  #page.should have_css(".account_status", :text => "Basic Personal Account")
end

When /^I see that "([^"]*)" has a premium account paid for by a different restaurant$/ do |username|
  user = User.find_by_username(username)
  # page.should have_css(".account_status",
  #     :text => "Premium Staff Account")
  # page.should have_css(".account_status",
  #     :text => "This account is paid for by a different restaurant.")
end

Then /^I see that "([^"]*)" has a premium account of his own$/ do |username|
  user = User.find_by_username(username)
  #page.should have_css(".account_status", :text => "Premium Personal Account")
end

Given /^I simulate a successful addon response from Braintree with (\d+)$/ do |count|
  # BraintreeConnector.expects(:set_add_ons_for_subscription).with(
  #     instance_of(Subscription), count.to_i).returns(stub(:success? => true))
end

Given /^user "([^"]*)" has a restaurant staff account from "([^"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  user.make_staff_account!(restaurant)
end

Then /^I do not see a link to change the user status$/ do
  page.should_not have_css(".account_info .status_change_links")
end

Then /^I see the information to enter billing$/ do
  #page.should have_css(".account_info .payment_info_needed")
end

Given /^I simulate a successful braintree update for "([^"]*)" with the complimentary discount$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  # BraintreeConnector.expects(:update_subscription_with_discount).with(
  #     restaurant.subscription).returns(stub(:success? => true))
end

Given /^I have a credit card on file with braintree$/ do
  @credit_card = {
    :last_4 => "1111",
    :expiration_month => "05",
    :expiration_year => "2015",
    :billing_address => {
      :postal_code => "11111"
    }
  }
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => stub(
        :credit_cards => [
          stub(
            :last_4 => @credit_card[:last_4],
            :expiration_month => @credit_card[:expiration_month],
            :expiration_year => @credit_card[:expiration_year],
            :billing_address => stub(
              :postal_code => @credit_card[:billing_address][:postal_code]
            )
          )
        ]
      )
    )
  # we're mocking the return of the customer object with a credit card record that looks like this:
  # [#<Braintree::CreditCard token: "6cgp", billing_address: #<Braintree::Address:0x105e4a830 @region=nil, @first_name=nil, @id="7h", @country_code_alpha2=nil, @country_name=nil, @postal_code="11111", @extended_address=nil, @updated_at=Thu Oct 28 19:17:51 UTC 2010, @company=nil, @locality=nil, @customer_id="User_208", @country_code_numeric=nil, @street_address=nil, @gateway=#<Braintree::Gateway:0x1061cd070 @config=#<Braintree::Configuration:0x1061c7788 @merchant_id="ny23sz9jy8gy38bw", @environment=:sandbox, @private_key="w8kw3smb2g2m6mds", @logger=#<Logger:0x1061ccfd0 @formatter=#<Logger::SimpleFormatter:0x1061b3e90 @datetime_format=nil>, @level=1, @default_formatter=#<Logger::Formatter:0x1061ccf80 @datetime_format=nil>, @progname=nil, @logdev=#<Logger::LogDevice:0x1061ccf30 @dev=#<IO:0x1001b4aa8>, @shift_size=nil, @shift_age=nil, @filename=nil, @mutex=#<Logger::LogDevice::LogDeviceMutex:0x1061cceb8 @mon_waiting_queue=[], @mon_entering_queue=[], @mon_count=0, @mon_owner=nil>>>, @public_key="n77z2dvd56jy4j9n", @custom_user_agent=nil>>, @last_name=nil, @country_code_alpha3=nil, @created_at=Thu Oct 28 19:17:51 UTC 2010>, bin: "411111", card_type: "Visa", cardholder_name: "", created_at: Fri Oct 22 20:05:45 UTC 2010, customer_id: "User_208", expiration_month: "01", expiration_year: "2011", last_4: "1111", updated_at: Thu Oct 28 19:17:51 UTC 2010>]

end

Then /^I should see my credit card information populated$/ do
  #page.should have_css("input", :value => "#{"*"*12}#{@credit_card[:last_4]}")
  #page.should have_css("input", :value => @credit_card[:billing_address][:postal_code])
  #page.should have_css("select[name*=expiration_month] option[selected]", :text => @credit_card[:expiration_month])
  #page.should have_css("select[name*=expiration_year] option[selected]", :value => @credit_card[:expiration_year])

end
