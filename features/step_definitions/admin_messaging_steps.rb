Given(/^there are no (?:QOTDs|Admin Messages|PR Tips)(?: in the system)?$/) do
  Admin::Message.destroy_all
end

Then /^the last holiday for "([^\"]*)" should be viewable by "([^\"]*)"$/ do |restaurantname,  employeename|
  restaurant = Restaurant.find_by_name!(restaurantname)
  user = User.find_by_name(employeename)
  employment = restaurant.employments.find_by_employee_id(user.id)

  restaurant.holidays.last.should be_viewable_by(employment)
end

Then /^the last holiday for "([^\"]*)" should not be viewable by "([^\"]*)"$/ do |restaurantname,  employeename|
  restaurant = Restaurant.find_by_name!(restaurantname)
  user = User.find_by_name(employeename)
  employment = restaurant.employments.find_by_employee_id(user.id)

  restaurant.holidays.last.should_not be_viewable_by(employment)
end

When /^I create a holiday with name "([^\"]*)" and criteria:$/ do |name, table|
  visit new_admin_holiday_path
  fill_in :name, :with => name
  fill_in "holiday_date_1i", :with => Date.today
  table.rows_hash.each do |field, value|
    check value
  end
  click_button
end

Given /^a holiday exists named "([^\"]*)" and restaurants:$/ do |holidayname, table|
  holiday = Factory(:holiday, :name => holidayname)

  table.hashes.each do |hash|
    if employee = Employment.employee_email_eq(hash['email']).first
      holiday.restaurants << employee
    end
  end

  holiday.save
  holiday.recipients.count.should == table.hashes.size
end

When /^I create a new reminder for holiday "([^\"]*)" with:$/ do |holidayname, table|
  holiday = Holiday.find_by_name(holidayname)
  visit new_admin_holiday_reminder_path, :get, :holiday_id => holiday.id

  table.rows_hash.each do |field, value|
    fill_in field, :with => value
  end

  click_button

  holiday.admin_holiday_reminders.count.should be > 0
end

When(/^I create a new QOTD with:$/) do |table|
  data = table.rows_hash
  visit new_admin_qotd_path
  fill_in 'Message', :with => data['Message']
  click_button :submit
end

Then(/^I should see list of (QOTD|Announcement|Holiday|PR Tip)s$/) do |klass|
  response.should contain(klass)
  response.should have_selector('table')
end

Then(/^"([^\"]*)" should have (\d+) QOTD messages?$/) do |username, num|
  user = User.find_by_username(username)
  user.admin_conversations(:conditions => {:type => 'Admin::Qotd' }).count.should == num.to_i
end

Then(/^"([^\"]*)" should have (\d+) Announcement messages?$/) do |username, num|
  user = User.find_by_username(username)
  user.announcements.count.should == num.to_i
end

Then(/^"([^\"]*)" should have (\d+) PR Tip messages?$/) do |username, num|
  user = User.find_by_username(username)
  user.pr_tips.count.should == num.to_i
end

Given(/^"([^\"]*)" has a QOTD message with:$/) do |username, table|
  data = table.rows_hash
  message = Factory(:qotd, data)

  user = User.find_by_username(username)
  recipient = user
  Factory(:admin_conversation, :admin_message => message, :recipient => recipient)
end

Given /^"([^\"]*)" has commented on "([^\"]*)" with "([^\"]*)"$/ do |username, qotd, comment|
  commentable = Admin::Qotd.find(:first, :conditions => { :message => qotd }).admin_conversations.first
  Factory(:comment, :comment => comment, :user_id => User.find_by_username(username).id, :commentable => commentable)
end

Given /^"([^\"]*)" has a trend question with:$/ do |username, table|
  data = table.rows_hash
  message = Factory(:trend_question, data)

  user = User.find_by_username(username)
  recipient = user.employments.first
  Factory(:admin_discussion, :discussionable => message, :restaurant => recipient.restaurant)
end

Given(/^"([^\"]*)" has a PR Tip message with:$/) do |username, table|
  data = table.rows_hash
  Factory(:pr_tip, data)
end

Then /^"([^\"]*)" should be subscribed to the holiday "([^\"]*)"$/ do |username, holidayname|
  holiday = Holiday.find_by_name!(holidayname)
  user = User.find_by_username!(username)
  holiday.restaurants.first.employees.should include(user)
end

Then /^the discussion for the trend question with subject "([^\"]*)" should have (\d+) comment$/ do |subject, num|
  trend_question = TrendQuestion.find_by_subject(subject)
  trend_question.discussions.last.comments_count.should == num.to_i
end

Given /^QOTD "([^\"]*)" has a reply "([^\"]*)"$/ do |qotd_name, reply|
  qotd = Admin::Qotd.find_by_message(qotd_name)
  Factory(:comment, :commentable => qotd.admin_conversations.first, :comment => reply)
end

Given /^trend question "([^\"]*)" has a reply "([^\"]*)"$/ do |question, reply|
  trend_question = TrendQuestion.find_by_subject(question)
  Factory(:comment, :commentable => trend_question.admin_discussions.first, :comment => reply)
end

Given /^trend question "([^\"]*)" has a reply "([^\"]*)" by "([^\"]*)"$/ do |question, reply, username|
  trend_question = TrendQuestion.find_by_subject(question)
  user = User.find_by_username(username)
  Factory(:comment, :commentable => trend_question.admin_discussions.first, :comment => reply, :user => user)
end

Given /^"([^\"]*)" has a holiday reminder for holiday "([^\"]*)" with:$/ do |restaurant, holidayname, table|
  holiday = Factory(:holiday, :name => holidayname, 
      :employment_search => Factory(:employment_search, :conditions => "--- \n:restaurant_name_like: #{restaurant}\n"))
  Factory(:holiday_reminder, table.rows_hash)
end

Given /^holiday "([^\"]*)" has a reply "([^\"]*)"$/ do |holidayname, reply|
  holiday = Holiday.find_by_name(holidayname)
  Factory(:comment, :commentable => holiday.holiday_discussions.first, :comment => reply)
end

Given /^"([^\"]*)" is not allowed to post to soapbox$/ do |username|
  user = User.find_by_username(username)
  visit edit_restaurant_employee_path(user.primary_employment.restaurant, user)
  uncheck :employment_post_to_soapbox
  click_button
end

Then /^the trend question "([^\"]*)" should not be viewable by "([^\"]*)"$/ do |qname, username|
  trendq = TrendQuestion.find_by_subject(qname)
  user = User.find_by_username(username)
  trendq.viewable_by?(user.primary_employment).should == false
end
