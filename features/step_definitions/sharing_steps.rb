Then /^I should see addThis button$/ do
  response.should have_selector(".addthis_button", :content =>"Share")
end

Then /^I should see two addThis buttons$/ do
  response.should have_selector('#question-of-the-day .addthis_button')
  response.should have_selector('#trend-identified .addthis_button')
end

Then /^addThis button should have public link$/ do
  response.should have_selector("script", :content => "url: ")
end

Then /^I should see link "see more"$/ do
  response.should have_selector(".see_more_link", :href =>"/dashboard_more")
end

Then /^I should see btl_game$/ do
  response.should have_selector("#btl_game")
end

Given /^answers with long text$/ do
  @profile_answer = Factory(:profile_answer, :answer => "some text "*50)
end

Given /^11 comments in dashboard$/ do
  11.times do
    Factory(:profile_answer)
  end
end

Then /^I should see facebook description tag with "([^\"]*)" within content$/ do |content|
  response.should have_xpath("//meta[@property='og:description'and@content='#{content}']")
end

Then /^I should see facebook description tag containing "([^\"]*)" within content$/ do |content|
  response.should have_xpath("//meta[contains(@content,\"#{content}\")and@property='og:description']")
end

