Given /^the following ([\w_]*) records?:?$/ do |factory, table|
  table.hashes.each do |row|
    Factory(factory, row)
  end
end

Given /^the current date is "([^\"]*)"$/ do |date|
  Date.stubs(:today).returns(Date.parse(date))
end

Then /^I should see "([^\"]*)" within "([^\"]*)"$/ do |text, title_of_area|
  response.should have_selector('div', :rel => title_of_area) do |div|
    div.should contain(text)
  end
end
