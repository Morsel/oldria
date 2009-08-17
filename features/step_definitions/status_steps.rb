Given /^"([^\"]*)" has the following status messages:$/ do |username, table|
  table.hashes.each do |row|
    u = User.find_by_username(username)
    Factory(:status, :user => u, :message => row['message'])
  end
end

Then /^the top message should be "([^\"]*)"$/ do |message|
  response.body.should have_selector('.status:first') do |status|
    status.should contain(message)
  end
end

Then /^the top message should not include a "([^\"]*)" tag$/ do |tag|
  response.body.should have_tag(".status") do |status|
    status.should_not have_tag(tag)
  end
end

Then /^I should see ([0-9]+) status updates?$/ do |num|
   response.body.should have_selector(".status", :count => num.to_i)
end

When /^the top message should contain a link to "([^\"]*)"$/ do |url|
  response.body.should have_tag(".status") do |status|
    status.should have_selector('a', :href => url)
  end
end
