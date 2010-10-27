Then /^I see my account status is not premium$/ do
  response.should have_selector("#plans .current", :content => "Basic")
end

Then /^I see that the restaurant's account status is basic$/ do
  response.should have_selector("#account_status", :content => "Basic")
end

Then /^I see that the restaurant's account status is premium$/ do
  response.should have_selector("#account_status", :content => "Premium")
end

Then /^I do not see a premium badge$/ do
  response.should_not have_selector(".premium_badge")
end

Then /^I see a link to update my account to premium$/ do
  response.should have_selector("#plans #upgrade_link a",
      :content => "Upgrade to Premium")
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

Then /^I see a premium badge$/ do
  response.should have_selector(".premium_badge")
end

Then /^I see my account status is premium$/ do
  response.should have_selector("#plans .current", :content => "Premium")
end

Then /^I see a link to cancel my account$/ do
  response.should have_selector("#plans #upgrade_link a",
      :content => "Downgrade to basic")
end

When /^I simulate braintree create behavior$/ do
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => nil)
end

When /^I simulate braintree update behavior$/ do
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => stub(:kind => 'update_customer', :credit_cards => [stub(:token => "token_abcd")])
      )
end

When /^I simulate a successful call from braintree for user "([^"]*)"$/ do |username|
  user = User.find_by_username(username)
  BraintreeConnector.any_instance.stubs(
      :confirm_request_and_start_subscription => stub(:success? => true,
          :subscription => stub(:id => "abcd")))
  visit(bt_callback_subscriptions_path(:customer_id => user.id,
      :subscriber_type => "user"))
end

When /^I simulate a successful call from braintree for the restaurant "([^"]*)"$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => nil)
  BraintreeConnector.any_instance.stubs(
      :confirm_request_and_start_subscription => stub(:success? => true,
          :subscription => stub(:id => "abcd")))
  visit(bt_callback_subscriptions_path(:customer_id => restaurant.id        ,
      :subscriber_type => "restaurant"))
end

When /^I simulate an unsuccessful call from braintree for user "([^"]*)"$/ do |username|
  user = User.find_by_username(username)
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => nil)
  BraintreeConnector.any_instance.stubs(
      :confirm_request_and_start_subscription => stub(:success? => false))
  visit(bt_callback_subscriptions_path(:customer_id => user.id, 
      :subscriber_type => "user"))
end

When /^I simulate an unsuccessful call from braintree for the restaurant "([^"]*)"$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => nil)
  BraintreeConnector.any_instance.stubs(
      :confirm_request_and_start_subscription => stub(:success? => false))
  visit(bt_callback_subscriptions_path(:customer_id => restaurant.id,
      :subscriber_type => "restaurant"))
end

When /^I simulate a successful cancel from braintree$/ do
  BraintreeConnector.any_instance.stubs(
      :cancel_subscription => stub(:success? => true))
  BraintreeConnector.stubs(:find_subscription).returns(
          stub(:billing_period_end_date => 1.month.from_now.to_date))
end

When /^I simulate an unsuccessful cancel from braintree$/ do
  BraintreeConnector.any_instance.stubs(
      :cancel_subscription => stub(:success? => false))
end

Then /^I see my account is paid for by myself$/ do
  response.should_not have_selector(".current", :content => "Complimentary")
  response.should have_selector(".current #start_date",
      :content => "since #{Date.today.to_s(:long)}")
end

When /^I traverse the delete link for subscriptions for user "([^"]*)"$/ do |username|
  visit(subscription_path(:id => User.find_by_username(username).id, 
          :subscriber_type => "customer"), 
      :delete)
end

When /^I traverse the delete link for subscriptions for the restaurant "([^"]*)"$/ do |name|
  visit(subscription_path(:customer_id => Restaurant.find_by_name(name).id,
          :subscriber_type => "restaurant"), 
      :delete)
end

Then /^I see that the account for "([^"]*)" lasts until the end of the billing cycle$/ do |username|
  user = User.find_by_username(username)
  response.should have_selector("#end_date",
      :content => user.subscription.end_date.to_s(:long))
end

Then /^I see that the restaurant account for "([^"]*)" lasts until the end of the billing cycle$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  response.should have_selector("#end_date",
      :content => restaurant.subscription.end_date.to_s(:long))
end


Then /^I don't see that the account for "([^"]*)" lasts until the end of the billing cycle$/ do |username|
  response.should_not have_selector("#end_date")
end

Then /^I don't see that the restaurant account for "([^"]*)" lasts until the end of the billing cycle$/ do |arg1|
  response.should_not have_selector("#end_date")
end


Then /^I do not see any account change options$/ do
  response.should_not have_selector("#upgrade_link")
end

Given /^the restaurant "([^"]*)" has a premium account$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.make_premium!(stub(:subscription => stub(:id => "abcd")))
  BraintreeConnector.stubs(:cancel_subscription).with(
      restaurant.subscription).returns(stub(:success? => true))
end

Given /^the restaurant "([^"]*)" has an overtime account$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.make_premium!(stub(:subscription => stub(:id => "abcd")))
  restaurant.subscription.update_attributes(:end_date => 1.month.from_now)
  # The cancel subscription call should never be made
  BraintreeConnector.stubs(:cancel_subscription).never
end

Given /^the restaurant "([^"]*)" does not have a premium account$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.subscription = nil
  restaurant.save!
end

Then /^I see that "([^"]*)" has a basic account$/ do |username|
  user = User.find_by_username(username)
  response.should have_selector(".account_status", :content => "Basic")
end

Then /^I see that "([^"]*)" has a premium account$/ do |username|
  user = User.find_by_username(username)
  response.should have_selector(".account_status", :content => "Premium")
end




