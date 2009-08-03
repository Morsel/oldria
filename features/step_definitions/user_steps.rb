Given /^there are no users$/ do
  User.count.should == 0
end

Given /^the following confirmed users?:?$/ do |table|
  table.hashes.each do |row|
    Factory(:user, row)
  end
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  unless username.blank?
    visit login_url
    fill_in "Username", :with => username
    fill_in "Password", :with => password
    click_button "Submit"
  end
end

Then /^"([^\"]*)" should be a confirmed user$/ do |username|
  User.find_by_username(username).should be_confirmed
end

