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
  user.update_attributes(:premium_account => true)
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

Given /^we know that we have valid credit card authorization$/ do
  FakeWeb.register_uri :post, %r|/merchants/ny23sz9jy8gy38bw/transparent_redirect_requests$|,
    :status => ["301", "Moved Permanently"],
    :location => bt_callback_subscriptions_url
end


When /^I simulate a successful call from braintree$/ do
  SubscriptionsController.any_instance.stubs(
      :find_braintree_customer => nil)
  SubscriptionsController.any_instance.stubs(
      :confirm_braintree_request => stub(:success? => true))
  SubscriptionsController.any_instance.stubs(
      :make_subscription_request => stub(:success? => true))
  visit(bt_callback_subscriptions_path)
end

When /^I simulate an unsuccessful call from braintree$/ do
  SubscriptionsController.any_instance.stubs(
      :find_braintree_customer => nil)
  SubscriptionsController.any_instance.stubs(
      :confirm_braintree_request => stub(:success? => true))
  SubscriptionsController.any_instance.stubs(
      :make_subscription_request => stub(:success? => false))
  visit(bt_callback_subscriptions_path)
end


