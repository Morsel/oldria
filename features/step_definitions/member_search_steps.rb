Then /^I should see (\d+) search results?$/ do |num|
  response.should have_tag('.search-result')
end

Then /^I should see no search results?$/ do
  response.should_not have_tag('.search-result')
end
