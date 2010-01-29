def verify_feed
  Feed.count.should be > 0
end

Given(/^that feed is featured$/) do
  verify_feed
  Feed.last.update_attribute(:featured, true)
end

Given(/^the feed with title "([^\"]*)" has the following entries:$/) do |feedtitle, table|
  feed = Feed.find_by_title(feedtitle)
  table.hashes.each do |hash|
     Factory(:feed_entry, hash.merge(:feed => feed))
  end
  feed.save
  feed.feed_entries.count.should == table.hashes.size
end

When(/^I create a new feed with:$/) do |table|
  visit new_admin_feed_path
  fill_in_form(table.rows_hash)
  click_button "Save"
end

Then(/^there should be (no|\d+) feeds? in the system$/) do |num|
  num = 0 if num == 'no'
  Feed.count.should == num.to_i
end

Then(/^the feed with title "([^\"]*)" should be featured$/) do |title|
  Feed.find_by_title(title).should be_featured
end


