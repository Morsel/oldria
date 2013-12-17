Given /^I have just posted a discussion with the title "([^\"]*)"$/ do |title|
  visit new_discussion_path
  # fill_in "Subject", :with => title
  # click_button("Post Discussion")
end

Given(/^there are no discussions(?: in the system)?$/) do
  Discussion.destroy_all
end

When(/^I visit that discussion$/) do
  # Discussion.count.should be > 0
  # visit discussion_path(Discussion.last)
end

Then(/^there should be (no|\d+) discussion(?: in the system)?$/) do |num|
  num = 0 if num == 'no'
  Discussion.count == num.to_i
end

Then /^"([^\"]*)" should have 1 discussion$/ do |login|
  User.find_by_login(login).discussions.count == 1
end