Given /^"([^\"]*)" has no headshot$/ do |username|
  User.find_by_username(username).should_not have_avatar
end

Given /^"([^\"]*)" has a headshot$/ do |username|
  u = User.find_by_username(username)
  u.avatar = File.open(Rails.root + "/features/support/paperclip/avatar/headshot.jpg")
  u.save
  u.should have_avatar
end

When /^I attach(?: an)? avatar "([^\"]*)" to "([^\"]*)"$/ do |attachment, field|
  attach_file(field, Rails.root + "/features/support/paperclip/avatar/#{attachment}")
end

Then /^"([^\"]*)" should have a headshot$/ do |username|
  User.find_by_username(username).should have_avatar
end

Then /^"([^\"]*)" should not have a headshot$/ do |username|
  User.find_by_username(username).should_not have_avatar
end

Then /^I should see (?:my|his|her|a) headshot$/ do
  page.should have_css("#profileImage img")
end

Then /^I should see my headshot thumbnail$/ do
  page.should have_css("img.thumbnail")
end
