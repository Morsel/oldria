Then /^I should see a list of events$/ do
  response.should have_selector("tbody") do |tbody|
    tbody.should have_selector("tr")
  end
end