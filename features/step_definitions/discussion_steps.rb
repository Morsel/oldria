Given /^I have just posted a discussion with the title "([^\"]*)"$/ do |title|
  visit new_discussion_path
  fill_in :title, :with => title
  click_button
end

Given(/^there are no discussions(?: in the system)?$/) do
  Discussion.destroy_all
end

When(/^I visit that discussion$/) do
  Discussion.count.should be > 0
  visit discussion_path(Discussion.last)
end

Then(/^there should be (no|\d+) discussion(?: in the system)?$/) do |num|
  num = 0 if num == 'no'
  Discussion.count.should == num.to_i
end

