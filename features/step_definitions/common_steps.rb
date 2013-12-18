Given /^the following ([\w_]*) records?:?$/ do |factory, table|
  # table.hashes.each do |row|
  #   #obj = FactoryGirl.create(factory, row)
  #   if factory == "user"
  #     FactoryGirl.create(:employment, :employee => obj)
  #   end
 # end
end

Given /^the current date is "([^\"]*)"$/ do |date|
  #Date.stubs(:today).returns(Date.parse(date))
end

Given /^I wait for all AJAX to finish$/ do
  # wait_until do
  #   page.evaluate_script('$.active') == 0
  # end
end

When /^I try to visit (.*)+$/ do |path|
  #visit path_to(path)
end

When /^I click on "([^\"]*)"$/ do |selector|
  page.should have_css("div", :id => selector) do |section|
  end
end

When /^I leave a comment with "([^\"]*)"$/ do |text|
  # fill_in "Comment", :with => text
  # click_button('Post Comment')
end

When /^I follow "([^\"]*)" within the "([^\"]*)" section$/ do |link, relselector|
  page.should have_css("div", :rel => relselector) do |section|
    click_link link
  end
end

When /^I attach an image "([^\"]*)" to "([^\"]*)"$/ do |attachment, field|
  attach_file(field, Rails.root + "/features/support/paperclip/image/#{attachment}")
end

When /^I attach the image "([^\"]*)" to "([^\"]*)" on S3$/ do |attachment, field|
  #attach_file(field, Rails.root + "/#{attachment}")
end

When /^(?:|I )attach the file "([^\"]*)" to "([^\"]*)" on S3$/ do |file_path, field|
  #attach_file(field, Rails.root + file_path)
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" time$/ do |time, selector|
  select_time(selector, :with => time)
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date$/ do |date, selector|
  select_date(selector, :with => date)
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date and time$/ do |datetime, selector|
  select_datetime(selector, :with => datetime)
end

Then /^I should see "([^\"]*)" within "([^\"]*)" section$/ do |text, title_of_area|
  page.should have_css('div', :rel => title_of_area) do |div|
    div.should contain(text)
  end
end

Then /^I should see a table of resources$/ do
  # page.should have_css("tbody") do |tbody|
  #   tbody.should have_css("tr")
  # end
end

Then /^I should see "([^\"]*)" as a link$/ do |text|
  #page.should have_css("a", :content => text)
end

Then /^I should see "([^\"]*)" as a link to "([^\"]*)"$/ do |text, link|
  page.should have_css("a", :href => link, :content => text)
end

Then /^the "([^\"]*)" div should have the class "([^\"]*)"$/ do |div_id, css_class|
  page.should have_css("div", :id => div_id, :class => css_class)
end

Then /^the "([^\"]*)" div should not have the class "([^\"]*)"$/ do |div_id, css_class|
  page.should_not have_css("div", :id => div_id, :class => css_class)
end

Then /^I should see an article with the "([^\"]*)" "([^\"]*)"$/ do |attribute, text|
  page.should have_css("article", attribute.to_sym => text)
end

Then /^I see more link to the answer's expanded view$/ do
  link = user_btl_chapter_path(@profile_answer.user, :id => @profile_answer.profile_question.chapter.id,
             :anchor => "profile_question_#{@profile_answer.profile_question_id}")
  #page.should have_css("a", :href => link)
  ""
end

Then /^there should be (\d+) page view(?:|s) in the system$/ do |count|
  PageView.count == count.to_i
end
