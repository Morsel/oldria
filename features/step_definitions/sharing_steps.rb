Then /^I should see addThis button$/ do
  response.should have_selector(".addthis_button", :content =>"Share")
end

Then /^I should see two addThis buttons$/ do
  response.should have_selector('#qotd') 
  response.should have_selector('#trend')
end

Then /^addThis button should have public link$/ do
  response.should have_selector("script", :content =>"soapbox" + current_url)
end

