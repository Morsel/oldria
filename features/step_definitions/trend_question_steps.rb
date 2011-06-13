When /^I create a new trend question with subject "([^\"]*)" with criteria:$/ do |subject, table|
  visit new_admin_trend_question_path
  fill_in :subject, :with => subject
  fill_in :body, :with => "Default body text"
  table.rows_hash.each do |field, value|
    check value
  end
  click_button :submit  
end

Then /^the trend question with subject "([^\"]*)" should have (\d+) restaurants?$/ do |subject, num|
  trend_question = TrendQuestion.find_by_subject(subject)
  trend_question.restaurants.count.should == num.to_i
end

Then /^the trend question with subject "([^\"]*)" should have (\d+) solo employments?$/ do |subject, num|
  trend_question = TrendQuestion.find_by_subject(subject)
  trend_question.employments.count.should == num.to_i
end

Then /^"([^\"]*)" should have (\d+)(?: new)? trend questions?$/ do |restaurant_name, num|
  Restaurant.find_by_name(restaurant_name).trend_questions.count.should == num.to_i
end

Then /^"([^\"]*)" should not have any(?: new)? trend questions?$/ do |restaurant_name|
  Restaurant.find_by_name(restaurant_name).trend_questions.count.should == 0
end

Then /^the last trend question for "([^\"]*)" should be viewable by "([^\"]*)"$/ do |restaurantname,  employeename|
  restaurant = Restaurant.find_by_name(restaurantname)
  user = User.find_by_name(employeename)
  employment = restaurant.employments.find_by_employee_id(user.id)
  
  restaurant.trend_questions.last.should be_viewable_by(employment)
end

Then /^the last trend question for "([^\"]*)" should not be viewable by "([^\"]*)"$/ do |restaurantname,  employeename|
  restaurant = Restaurant.find_by_name(restaurantname)
  user = User.find_by_name(employeename)
  employment = restaurant.employments.find_by_employee_id(user.id)
  
  restaurant.trend_questions.last.should_not be_viewable_by(employment)
end
