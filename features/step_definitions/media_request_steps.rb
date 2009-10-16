def visit_and_fill_out_form_and_submit(recipient_ids = [], message = "", duedate = "2009-12-01")
  visit new_media_request_path(:recipient_ids => recipient_ids)
  fill_in 'media_request[message]', :with => message
  select_date(duedate)
  click_button :submit
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
  user = User.find_by_username(username)
  sender = User.find_by_username(mediauser)
  Factory(:media_request, :recipients => [user], :sender => sender, :message => message)
end

When /^I leave a comment with "([^\"]*)"$/ do |text|
  fill_in "Comment", :with => text
  click_button :submit
end
