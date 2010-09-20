Given /^a restaurant named "([^\"]*)"$/ do |name|
  @restaurant = Factory(:managed_restaurant, :name => name)
end

Then /^I see the restaurant's name as "([^\"]*)"$/ do |name|
  response.should have_selector("#name", :content => name)
end

Then /^I see the restaurant's description$/ do
  response.should have_selector("#description", :content => @restaurant.description)
end

When /^I see the address$/ do
  response.should have_selector("#street1", :content => @restaurant.street1)
  response.should have_selector("#street2", :content => @restaurant.street2)
  response.should have_selector("#city", :content => @restaurant.city)
  response.should have_selector("#state", :content => @restaurant.state)
  response.should have_selector("#zip", :content => @restaurant.zip)
end

Then /^I see the phone number$/ do
  response.should have_selector("#phone_number", :content => @restaurant.phone_number)
end

Then /^I see the restaurant's website$/ do
  response.should have_selector("#website", :content => @restaurant.website)
end

Then /^I see the restaurant's Twitter username$/ do
  response.should have_selector("#twitter_username", :content => @restaurant.twitter_username)
end

Then /^I see the restaurant's Facebook page$/ do
  response.should have_selector("#facebook_page", :content => @restaurant.facebook_page)
end

When /^I see the restaurant's hours$/ do
  response.should have_selector("#hours", :content => @restaurant.hours)
end

Then /^I see media contact name, phone, and email$/ do
  response.should have_selector("#media_contact_name", :content => @restaurant.media_contact.name)
  response.should have_selector("#media_contact_phone", :content => @restaurant.media_contact.phone_number)
  response.should have_selector("#media_contact_email", :content => @restaurant.media_contact.email)
end

Then /^I see the management company name as a link$/ do
  response.should have_selector("#management_company a", :content => @restaurant.management_company_name)
end

