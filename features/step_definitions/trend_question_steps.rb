When /^I create a new trend question with subject "([^\"]*)" with criteria:$/ do |subject, table|
  visit new_admin_trend_question_path
  fill_in :subject, :with => subject
  table.rows_hash.each do |field, value|
    select value, :from => field
  end
  click_button :submit
end

Then /^"([^\"]*)" should have (\d+) new trend questions?$/ do |restaurant_name, num|
  Restaurant.find_by_name(restaurant_name).trend_questions.count.should == num.to_i
end

Then /^"([^\"]*)" should not have any new trend questions?$/ do |restaurant_name|
  Restaurant.find_by_name(restaurant_name).trend_questions.count.should == 0
end
