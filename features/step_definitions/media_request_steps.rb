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

def find_media_requests_for_username(username)
  user = User.find_by_username(username)
  media_requests = user.viewable_media_requests
end

Given /^subject matter "([^\"]*)" is general$/ do |name|
  s = SubjectMatter.find_or_create_by_name(name)
  s.update_attribute(:general, true)
end

Given /^a non\-general subject matter "([^\"]*)"$/ do |name|
  FactoryGirl.create(:subject_matter, :name => name, :general => false)
end

Given /^"([^\"]*)" handles the subject matter "([^"]*)" for "([^"]*)"$/ do |username, subject, restname|
  r = Restaurant.find_by_name(restname)
  u = User.find_by_username(username)
  subject_matter = SubjectMatter.find_or_create_by_name(subject)
  employment = u.employments.find_by_restaurant_id(r.id)
  employment.subject_matters << subject_matter
  employment.save
end

Given /^"([^\"]*)" does not handle the subject matter "([^"]*)" for "([^"]*)"$/ do |username, subject, restname|
  r = Restaurant.find_by_name(restname)
  u = User.find_by_username(username)
  employment = u.employments.find_by_restaurant_id(r.id)
  employment.responsibilities.destroy_all
end

Given /^there are no media requests$/ do
  MediaRequest.destroy_all
end

Given /^"([^\"]*)" has a media request$/ do |username|
  subject_matter = FactoryGirl.create(:subject_matter)
  user = User.find_by_username(username)
  FactoryGirl.create(:employment, :employee => user) if user.restaurants.blank?
  Given %Q["#{username}" handles the subject matter "#{subject_matter.name}" for "#{user.restaurants.first.name}"]
  @media_request = FactoryGirl.create(:media_request, :subject_matter => subject_matter)
  @media_request.approve!
end

Given /^"([^\"]*)" has a media request from a media member with:$/ do |username, table|
  FactoryGirl.create(:media_user, :username => "media")
  Given %Q{"#{username}" has a media request from "media" with:}, table
end

Given /^"([^\"]*)" has a media request from "([^\"]*)" with:$/ do |username, mediauser, table|
  message = table.rows_hash['Message']
  status = table.rows_hash['Status'] || 'pending'

  user = User.find_by_username(username)
  FactoryGirl.create(:employment, :employee => user) if user.restaurants.blank?

  sender = User.find_by_username(mediauser)
  publication = table.rows_hash['Publication'] || sender.publication

  search = EmploymentSearch.new(:conditions => { :id_eq => user.primary_employment.id })

  @media_request = FactoryGirl.create(:media_request, :employment_search => search, :sender => sender,
                           :message => message, :status => status, :publication => publication)
end

When /^I create a media request with message "([^\"]*)" and criteria:$/ do |message, criteria|
  visit new_mediafeed_media_request_path
  fill_in "Message", :with => message
  criteria.rows_hash.each do |field, value|
    if field =~ /(Type of Request)/i
      select value, :from => field
    else
      check value
    end
  end
  click_button "Submit"
  @media_request = MediaRequest.last
end

When /^I create a new media request with:$/ do |table|
  media_request_from_hash(table.rows_hash)
  click_button "Submit"
  @media_request = MediaRequest.last
end

When /^I create a new admin media request with:$/ do |table|
  hash_data = table.rows_hash
  media_request_from_hash(hash_data)
  check "Admin"
  select hash_data["Status"], :from => :status if hash_data["Status"]
  click_button "Submit"
  @media_request = MediaRequest.last
end

When /^I visit the media request discussion page for "([^\"]*)"$/ do |message|
  media_request = MediaRequest.find_by_message(message)
  visit media_request_discussion_path(media_request.media_request_discussions.first)
end

When /^I visit the Mediafeed media request discussion page for "([^\"]*)"$/ do |message|
  media_request = MediaRequest.find_by_message(message)
  visit mediafeed_discussion_path(media_request, 'media_request_discussions', media_request.media_request_discussions.first)
end

Given /^an admin has approved the media request from "([^\"]*)"$/ do |username|
  Given("I am logged in as an admin")
  visit admin_media_requests_path
  page.should contain(User.find_by_username(username).name)
  click_link "approve"
end

Then /^I should see a list of media requests$/ do
  Then("I should see a table of resources")
end

When /^I perform the raw search:$/ do |table|
  visit new_mediafeed_media_request_path(:search => table.rows_hash)
end

When "I perform the search:" do |table|
  searchcriteria = table.rows_hash
  searchcriteria.each do |field, value|
    if ['Region', 'Greater Metropolitan Area', 'Subject Matter', 'Role at Restaurant', 'Restaurant Name'].include?(field)
      check value
    else
      fill_in field, :with => value
    end
  end
  click_button "Search"
end

When /^I approve the media request$/ do
  click_link "edit"
  select "Approved", :from => :status
  click_button "Save"
end

When /^that media request is approved$/ do
  @media_request ||= MediaRequest.last
  @media_request.approve!
end

Then /^the media request from "([^\"]*)" should be (.+)$/ do |username, status|
  media_requests = User.find_by_username(username).viewable_media_requests
  media_requests.last.status.should == status
end

Then /^the media request for "([^\"]*)" should be (.+)$/ do |username, status|
  media_requests = User.find_by_username(username).viewable_media_requests
  media_requests.last.status.should == status
end

Then /^that media request should be (.+)$/ do |status|
  @media_request ||= MediaRequest.last
  @media_request.status.should == status
end

Then(/^"([^\"]*)" should have ([0-9]+) media requests?$/) do |username,num|
  media_requests = User.find_by_username(username).viewable_media_requests
  media_requests.size.should == num.to_i
end

Then(/^there should be (\d+) media requests?(?: in the system)?$/) do |num|
  MediaRequest.count.should == num.to_i
end

Then /^the media request should have ([0-9]+) comments?$/ do |num|
  MediaRequest.last.discussions.sum(&:comments_count).should == num.to_i
end

Then /^I should see an admin media request$/ do
  page.should have_css(".media_request.admin")
end
