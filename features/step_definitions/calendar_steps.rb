Then /^I should see a list of events$/ do
  page.should have_css("tbody") do |tbody|
    tbody.should have_css("tr")
  end
end