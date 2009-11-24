Given /^"([^\"]*)" has no headshot$/ do |username|
  User.find_by_username(username).should_not have_avatar
end

Given /^"([^\"]*)" has a headshot$/ do |username|
  u = User.find_by_username(username)
  u.avatar = File.open(RAILS_ROOT + "/features/support/paperclip/avatar/headshot.jpg")
  u.save
  u.should have_avatar
end


When /^I attach(?: an)? avatar "([^\"]*)" to "([^\"]*)"$/ do |attachment, field|
  attach_file(field, RAILS_ROOT + "/features/support/paperclip/avatar/#{attachment}", "image/jpg")
end

Then /^"([^\"]*)" should have a headshot$/ do |username|
  User.find_by_username(username).should have_avatar
end

Then /^"([^\"]*)" should not have a headshot$/ do |username|
   User.find_by_username(username).should_not have_avatar
end

Then /^I should see (?:my|his|her|a) headshot$/ do
  response.should have_tag("img", :class => 'thumbnail')
end
