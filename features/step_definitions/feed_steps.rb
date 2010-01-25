When(/^I create a new feed with:$/) do |table|
  visit new_admin_feed_path
  fill_in_form(table.rows_hash)
  click_button "Save"
end


Then (/^there should be (no|\d+) feeds? in the system$/) do |num|
  num = 0 if num == 'no'
  Feed.count.should == num.to_i
end

Then /^the feed with title "([^\"]*)" should be featured$/ do |title|
  Feed.find_by_title(title).should be_featured
end
