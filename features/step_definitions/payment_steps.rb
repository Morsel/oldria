Then /^I see my account status is not premium$/ do
  response.should have_selector("#plans .current", :content => "Basic")
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

When /^I simulate a successful call from braintree for user "([^"]*)"$/ do |username|
  user = User.find_by_username(username)
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => nil)
  BraintreeConnector.any_instance.stubs(
      :confirm_request_and_start_subscription => stub(:success? => true,
          :subscription => stub(:id => "abcd")))
  visit(bt_callback_subscriptions_path(:id => user.id))
end

When /^I simulate an unsuccessful call from braintree for user "([^"]*)"$/ do |username|
  user = User.find_by_username(username)
  BraintreeConnector.any_instance.stubs(
      :braintree_customer => nil)
  BraintreeConnector.any_instance.stubs(
      :confirm_request_and_start_subscription => stub(:success? => false))
  visit(bt_callback_subscriptions_path(:id => user.id))
end

When /^I simulate a successful cancel from braintree$/ do
  BraintreeConnector.any_instance.stubs(
      :cancel_subscription => stub(:success? => true))
  BraintreeConnector.stubs(:find_subscription).returns(
          stub(:subscription => 
              stub(:billing_period_end_date => 1.month.from_now.to_date)))
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
  visit(subscription_path(:id => User.find_by_username(username).id), :delete)
end

Then /^I see that the account for "([^"]*)" lasts until the end of the billing cycle$/ do |username|
  user = User.find_by_username(username)
  response.should have_selector("#end_date",
      :content => user.subscription.end_date.to_s(:long))
end

Then /^I don't see that the account for "([^"]*)" lasts until the end of the billing cycle$/ do |username|
  response.should_not have_selector("#end_date")
end



