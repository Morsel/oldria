Then /^I should see addThis button$/ do
  page.should have_css(".addthis_button", :content =>"Share")
end

Then /^I should see two addThis buttons$/ do
  page.should have_css('#question-of-the-day .addthis_button')
  page.should have_css('#trend-identified .addthis_button')
end

Then /^addThis button should have public link$/ do
  page.should have_css("script", :content => "url: ")
end

Then /^I should see link "see more"$/ do
  #page.should have_css(".see_more_link", :href =>"/dashboard_more")
  ""
end

Then /^I should see btl_game$/ do
  page.should have_css("#btl_game")
end

Given /^answers with long text$/ do
  @profile_answer = FactoryGirl.create(:profile_answer, :answer => "some text "*50)
end

Given /^11 comments in dashboard$/ do
  11.times do
    FactoryGirl.create(:profile_answer)
  end
end

Then /^I should see facebook description tag with "([^\"]*)" within content$/ do |content|
  page.should have_xpath("//meta[@property='og:description'and@content='#{content}']")
end

Then /^I should see facebook description tag containing "([^\"]*)" within content$/ do |content|
  page.should have_xpath("//meta[contains(@content,\"#{content}\")and@property='og:description']")
end

