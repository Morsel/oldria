Then /^I should see the admin interface$/ do
  true #TODO
end

Then /^I should see the static page name "([^\"]*)"$/ do |title|
  Then "I should see \"#{title}\""
end

Then /^I should see the "([^\"]*)" error message$/ do |arg1|
  true #TODO
end

