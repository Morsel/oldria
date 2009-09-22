Given /^there are no users$/ do
  User.count.should == 0
end

Given /^the following confirmed users?:?$/ do |table|
  table.hashes.each do |row|
    Factory(:user, row)
  end
end

Given /^I am logged in as an admin$/ do
  Factory(:admin, :username => 'admin', :password => 'admin')
  Given 'I am logged in as "admin" with password "admin"'
end

Given /^I am logged in as a normal user$/ do
  Factory(:user, :username => 'normal', :password => 'normal')
  Given 'I am logged in as "normal" with password "normal"'
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  unless username.blank?
    visit login_url
    fill_in "Username", :with => username
    fill_in "Password", :with => password
    click_button "Login"
  end
end

Given /^"([^\"]*)" has a "([^\"]*)" account type$/ do |username, account_type_name|
  account_type = AccountType.find_by_name(account_type_name)
  account_type ||= Factory(:account_type, :name => account_type_name)
  user = User.find_by_username(username)
  user.account_type = account_type
  user.save
end

When /^I (?:visit the logout path|logout)$/ do
  visit logout_url
end

Then /^"([^\"]*)" should be a confirmed user$/ do |username|
  User.find_by_username(username).should be_confirmed
end

Then /^"([^\"]*)" should not be logged in$/ do |username|
  User.find_by_username(username).should_not be_logged_in
end

Then /^"([^\"]*)" should be logged in$/ do |username|
  User.find_by_username(username).should be_logged_in
end

Then /^"([^\"]*)" should be an admin$/ do |username|
  User.find_by_username(username).should be_admin
end

Then /^"([^\"]*)" should have an? "([^\"]*)" account type$/ do |username, account_type_name|
  User.find_by_username(username).account_type.name.should == account_type_name
end

Then /^I should see that "([^\"]*)" has a "([^\"]*)" account type$/ do |username, account_type_name|
  response.should have_selector(".user") do |usertag|
    usertag.should contain(username)
    usertag.should contain(account_type_name)
  end
end


