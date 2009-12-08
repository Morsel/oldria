def find_media_requests_for_username(username)
  user = User.find_by_username(username)
  ids = user.media_request_conversations.map(&:media_request_id).uniq
  media_requests = MediaRequest.find(ids)
end

Given /^"([^\"]*)" has a media request from a media member with:$/ do |username, table|
  Factory(:media_user, :username => "media")
  Given %Q{"#{username}" has a media request from "media" with:}, table
end

Given /^"([^\"]*)" has a media request from "([^\"]*)" with:$/ do |username, mediauser, table|
  message = table.rows_hash['Message']
  status = table.rows_hash['Status'] || 'pending'
  user = User.find_by_username(username)
  user.should_not be_nil
  employment = Factory(:employment, :employee => user)
  sender = User.find_by_username(mediauser)
  publication = table.rows_hash['Publication'] || sender.publication
  Factory(:media_request, :recipients => [employment], :sender => sender, :message => message, :status => status, :publication => publication)
end


Given /^there are no media requests$/ do
  MediaRequest.destroy_all
end


When /^I follow "([^\"]*)" within the "([^\"]*)" section$/ do |link, relselector|
  response.should have_selector("div", :rel => relselector) do |section|
    click_link link
  end
end

Then /^the media request should have ([0-9]+) comments?$/ do |num|
  MediaRequestConversation.last.comments.count.should == num.to_i
end


When /^I search for and find "([^\"]*)" restaurant$/ do |restaurantname|
  When("I search for \"#{restaurantname}\" restaurant")
  check restaurantname
  click_button "Next"
end

When /^I search for "([^\"]*)" restaurant$/ do |restaurantname|
  restaurant = Restaurant.find_or_create_by_name(restaurantname)
  visit new_media_request_path
  fill_in "Restaurant", :with => restaurantname
  click_button "Search"
end


When /^I perform the search:$/ do |table|
  searchcriteria = table.rows_hash
  searchcriteria.each do |field, value|
    if %w{Region}.include?(field)
      check value
    else
      fill_in field, :with => value
    end
  end
  click_button "Search"
end

When /^I select "([^\"]*)" as a recipient$/ do |name|
  # Restaurant Name
  check name
end

def media_request_from_hash(hash_data)
  recipient_ids = []
  if hash_data['Recipients']
    hash_data['Recipients'].split(", ").each do |username|
      user = User.find_by_username(username)
      recipient_ids << Employment.find_by_user_id(user.id).id
    end
  end
  fill_in 'media_request[message]', :with => hash_data["Message"]
  select_date(hash_data["Due date"] || 2009-12-01)
end

When /^I create a new media request with:$/ do |table|
  media_request_from_hash(table.rows_hash)
  click_button :submit
end

When /^I create a new admin media request with:$/ do |table|
  hash_data = table.rows_hash
  media_request_from_hash(hash_data)
  check "Admin"
  select hash_data["Status"], :from => :status if hash_data["Status"]
  click_button :submit
end

Given /^an admin has approved the media request from "([^\"]*)"$/ do |username|
  Given("I am logged in as an admin")
  visit admin_media_requests_path
  response.should contain(User.find_by_username(username).name)
  click_link "approve"
end


When /^I leave a comment with "([^\"]*)"$/ do |text|
  fill_in "Comment", :with => text
  click_button :submit
end

Then /^I should see a list of media requests$/ do
  response.should have_selector("tbody") do |tbody|
    tbody.should have_selector("tr")
  end
end

When /^I approve the media request$/ do
  click_link "edit"
  select "Approved", :from => :status
  click_button "Save"
end

Then /^the media request from "([^\"]*)" should be pending$/ do |username|
  media_requests = User.find_by_username(username).media_requests
  media_requests.last.should be_pending
end

Then /^the media request for "([^\"]*)" should be pending$/ do |username|
  media_requests = find_media_requests_for_username(username)
  media_requests.last.should be_pending
end

Then /^the media request for "([^\"]*)" should be approved$/ do |username|
  media_requests = find_media_requests_for_username(username)
  media_requests.last.should be_approved
end

Then(/^"([^\"]*)" should have ([0-9]+) media requests?$/) do |username,num|
  media_requests = find_media_requests_for_username(username)
  media_requests.size.should == num.to_i
end

Then(/^"([^\"]*)" should have a(?: new)? draft media request$/) do |username|
  media_requests = User.find_by_username(username).media_requests
  media_requests.last.status.should == 'draft'
end

Then(/^there should be ([0-9]+) media requests?(?: in the system)?$/) do |num|
  MediaRequest.count.should == num.to_i
end

Then /^I should see an admin media request$/ do
  response.should have_selector(".media_request.admin")
end
