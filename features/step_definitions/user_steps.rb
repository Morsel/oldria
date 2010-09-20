Given /^there are no users$/ do
  User.count.should == 0
end

Given /^the following confirmed users?:?$/ do |table|
  table.hashes.each do |row|
    user = Factory(:user, row)
  end
end

Given /^the following unconfirmed users?:?$/ do |table|
  table.hashes.each do |row|
    user = Factory(:user, row.merge(:confirmed_at => nil))
  end
end

Given /^the following media users?:?$/ do |table|
  table.hashes.each do |row|
    user = Factory(:media_user, row)
  end
end

Given /^a media user "([^\"]*)" has just signed up$/ do |username|
  visit new_media_user_path

  When 'I sign up with:', table(%Q{
    | username    | email        | password |
    | #{username} | jimbo@bo.com | secret   |
  })

  @user = User.find_by_username(username)
end

Given /^I am logged in as an admin$/ do
  Factory(:admin, :username => 'admin', :password => 'admin')
  Given 'I am logged in as "admin" with password "admin"'
end

Given /^I am logged in as a normal user$/ do
  Factory(:user, :username => 'normal', :password => 'normal')
  Given 'I am logged in as "normal" with password "normal"'
end

Given /^I am logged in as a normal user with a profile$/ do
  user = Factory(:user, :username => 'normal', :password => 'normal')
  Factory(:profile, :user => user)
  Factory(:employment, :employee => user)
  Given 'I am logged in as "normal" with password "normal"'
end

Given /^I am logged in as a spoonfeed member$/ do
  Given("I am logged in as a normal user")
end

Given /^I am logged in as a media member$/ do
  user = User.find_by_username("media")
  user ||= Factory(:media_user, :username => 'media', :password => 'normal')
  user.has_role! :media
  Given 'I am logged in as "media" with password "normal"'
end


Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  unless username.blank?
    visit login_url
    fill_in "Username", :with => username
    fill_in "Password", :with => password
    click_button "Login"
  end
  @current_user = User.find_by_username(username)
end

Given(/^I am logged in as "([^\" ]*)"$/) do |username|
  Given %Q(I am logged in as "#{username}" with password "secret")
end

Given /^I am not logged in$/ do
  Given 'I visit the logout path'
end

When /^I (?:visit the logout path|logout)$/ do
  visit logout_url
end

When /^I sign up with:$/ do |table|
  user_data = table.hashes.first
  user_data.each do |field, value|
    fill_in "user[#{field}]", :with => value
  end
  fill_in "user[password_confirmation]", :with => user_data["password"] if user_data["password"]
  click_button :submit
end

When /^I confirm my account$/ do
  When 'I open the email with subject "Welcome to SpoonFeed! Please confirm your account"'
  When 'I click the first link in the email'
end

Then /^"([^\"]*)" should be marked as a media user$/ do |username|
  u = User.find_by_username(username)
  u.should have_role(:media)
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


Then /^I should see an invitation URL in the email body$/ do
  token = User.find_by_email(current_email.to).perishable_token
  current_email.body.should =~ Regexp.new(token)
end

Then /^"([^\"]*)" should still exist$/ do |username|
  User.find_by_username(username).should_not be_nil
end

Given /^given that user "([^\"]*)" has just been confirmed$/ do |username|
  user = User.find_by_username(username)
  user.confirm!
end
