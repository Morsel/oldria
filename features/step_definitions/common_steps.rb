Given /^the following ([\w_]*) records?:?$/ do |factory, table|
  table.hashes.each do |row|
    obj = Factory(factory, row)
    if factory == "user"
      Factory(:employment, :employee => obj)
    end
  end
end

Given /^the current date is "([^\"]*)"$/ do |date|
  Date.stubs(:today).returns(Date.parse(date))
end

Then /^I should see "([^\"]*)" within "([^\"]*)" section$/ do |text, title_of_area|
  response.should have_selector('div', :rel => title_of_area) do |div|
    div.should contain(text)
  end
end

When /^I try to visit (.*)+$/ do |path|
  visit path_to(path)
end

When /^I click on "([^\"]*)"$/ do |selector|
  response.should have_selector("div", :id => selector) do |section|
  end
end

When /^I leave a comment with "([^\"]*)"$/ do |text|
  fill_in "Comment", :with => text
  click_button
end

When /^I follow "([^\"]*)" within the "([^\"]*)" section$/ do |link, relselector|
  response.should have_selector("div", :rel => relselector) do |section|
    click_link link
  end
end

Then /^I should see a table of resources$/ do
  response.should have_selector("tbody") do |tbody|
    tbody.should have_selector("tr")
  end
end

Then /^I should see "([^\"]*)" as a link$/ do |text|
  response.should have_selector("a", :content => text)
end

Then /^the "([^\"]*)" div should have the class "([^\"]*)"$/ do |div_id, css_class|
  response.should have_selector("div", :id => div_id, :class => css_class)
end

Then /^the "([^\"]*)" div should not have the class "([^\"]*)"$/ do |div_id, css_class|
  response.should_not have_selector("div", :id => div_id, :class => css_class)
end

