def visit_and_fill_out_form_and_submit(recipient_ids = [], message = "", duedate = "2009-12-01")
  visit new_media_request_path(:recipient_ids => recipient_ids)
  fill_in 'media_request[message]', :with => message
  select_date(duedate)
  click_button :submit
end

def find_media_requests_for_username(username)
  User.find_by_username(username).received_media_requests
end

Given /^"([^\"]*)" has a media request from a media member with:$/ do |username, table|
  Given('I am logged in as a media member')
  recipient_ids = [User.find_by_username(username).id]
  visit_and_fill_out_form_and_submit(recipient_ids, table.rows_hash["Message"])
end


When /^I follow "([^\"]*)" within the "([^\"]*)" section$/ do |link, relselector|
  response.should have_selector("div", :rel => relselector) do |section|
    click_link link
  end
end

Then /^the media request should have ([0-9]+) comments?$/ do |num|
  MediaRequestConversation.first.comments.count.should == num.to_i
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
  # check
  check 'recipient_ids[]'
end


When /^I create a new media request with:$/ do |table|
  mrdata = table.rows_hash
  recipient_ids = []
  if mrdata['Recipients']
    mrdata['Recipients'].split(", ").each do |username|
      recipient_ids << User.find_by_username(username).id
    end
  end
  visit_and_fill_out_form_and_submit(recipient_ids, mrdata["Message"], mrdata["Due date"])
end

Given /^"([^\"]*)" has a media request from "([^\"]*)" with:$/ do |username, mediauser, table|
  message = table.rows_hash['Message']
  status = table.rows_hash['Status'] || 'pending'
  user = User.find_by_username(username)
  sender = User.find_by_username(mediauser)
  publication = table.rows_hash['Publication'] || sender.publication
  Factory(:media_request, :recipient_ids => [user.id], :sender => sender, :message => message, :status => status, :publication => publication)
end

Given /^an admin has approved the media request for "([^\"]*)"$/ do |username|
  Given("I am logged in as an admin")
  visit admin_media_requests_path
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

Then /^the media request for "([^\"]*)" should be pending$/ do |username|
  media_requests = find_media_requests_for_username(username)
  media_requests.last.should be_pending
end

Then /^the media request for "([^\"]*)" should be approved$/ do |username|
  media_requests = find_media_requests_for_username(username)
  media_requests.last.should be_approved
end

Then /^"([^\"]*)" should have ([0-9]+) media request$/ do |username,num|
  media_requests = find_media_requests_for_username(username)
  media_requests.size.should == num.to_i
end


