Given /^"([^\"]*)" has the following status messages:$/ do |username, table|
  table.hashes.each do |row|
    u = User.find_by_username(username)
    FactoryGirl.create(:status, :user => u, :message => row['message'])
  end
end

Then /^the top message should be "([^\"]*)"$/ do |message|
  # within ".status:first" do
  #   page.should have_content(message)
  # end
end

Then /^the top message should not include a "([^\"]*)" tag$/ do |tag|
  # within ".status" do
  #   page.should_not have_css(tag)
  # end
end

Then /^I should see ([0-9]+) status updates?$/ do |num|
   page.should have_css(".status", :count => num.to_i)
end

When /^the top message should contain a link to "([^\"]*)"$/ do |url|
  # within ".status" do
  #   page.should have_link(url)
  # end
end
