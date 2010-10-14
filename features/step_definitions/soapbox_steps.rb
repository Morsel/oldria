Given /^there is a QOTD asking "([^\"]*)"$/ do |text|
  @qotd = Factory(:qotd, :message => text)
end

Given /^that QOTD has the following answers:$/ do |table|
  @qotd ||= Admin::Qotd.last
  table.rows_hash.each do |name, response|
    # create the user
    user = Factory(:user, :name => name)
    employment = Factory(:employment, :employee => user)

    # Add as recipients to QOTD
    conversation = @qotd.admin_conversations.create(:recipient_id => employment.id)

    # Add the comment
    conversation.comments.create(:user_id => user.id, :comment => response)
  end
end

When /^I create a new soapbox entry for that QOTD with:$/ do |table|
  visit new_admin_soapbox_entry_path(:qotd_id => @qotd.to_param)

  table.rows_hash.each do |field, value|
    fill_in field, :with => value
  end

  click_button "Save"
end

When /^I create a new soapbox page with:$/ do |table|
  visit new_admin_soapbox_page_path
  fill_in_form(table.rows_hash)
  click_button "Save"
end

Then /^there should be (\d+) QOTDs? on the soapbox landing page$/ do |num|
  visit root_url(:subdomain => 'soapbox')
  SoapboxEntry.qotd.published.count.should == num.to_i
end

Then /^I see a navigation link for "([^\"]*)"$/ do |header_name|
  response.should have_selector(".page_nav_link a", :content => header_name)
end

Then /^I do not see a navigation link for "([^\"]*)"$/ do |header_name|
  response.should_not have_selector(".page_nav_link a", :content => header_name)
end

Then /^I see a page header for "([^\"]*)" with "([^\"]*)"$/ do |page, tags|
  page_obj = RestaurantFeaturePage.find_by_name(page)
  response.should have_selector(".feature_page_header", :content => page)
  tags.split(",").each do |tag|
    response.should have_selector("##{dom_id(page_obj)} .feature", :content => tag.strip)
  end
end

Then /^I do not see a page header for "([^\"]*)"$/ do |page|
  response.should_not have_selector(".feature_page_header", :content => page)
end

Then /^I should see an accolade link$/ do
  response.should have_selector(".accolade_link")
end

Then /^I should not see an accolade link$/ do
  response.should_not have_selector(".accolade_link")
end

Then /^I should see an employee named "([^\"]*)"$/ do |name|
  response.should contain(name)
end

Then /^I should see the employees in the order "([^"]*)"$/ do |employee_names|
  expected_names = tableish(".public_employee", ".employee_name")
  expected_names = expected_names.flatten.map { |n| n.gsub(",", "") }
  expected_names.should == employee_names.split(",").map(&:strip)
end

When /^that "([^\"]*)" (has|does not have) a premium account$/ do |restaurant_name, toggle|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.update_attributes(:premium_account => toggle == "has")
end

Then /^I see an employee named "([^"]*)" with a link$/ do |username|
  user = User.find_by_username(username)
  response.should have_selector(".employee_name a", :content => user.name)
end

Then /^I see an employee named "([^"]*)" without a link$/ do |username|
  user = User.find_by_username(username)
  response.should have_selector(".employee_name", :content => user.name)
  response.should_not have_selector(".employee_name a", :content => user.name)
end

Then /^I should see the heading "([^"]*)"$/ do |text|
  response.should have_selector("h2", :content => text)
end