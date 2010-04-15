Given(/^there are no (?:QOTDs|Admin Messages)(?: in the system)?$/) do
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
  table.rows_hash.each do |field, value|
    select value, :from => field
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

When(/^I create a new QOTD with:$/)do |table|
  data = table.rows_hash
  visit new_admin_qotd_path
  fill_in 'Message', :with => data['Message']
  click_button :submit
end

Then(/^I should see list of (QOTD|Announcement|Holiday)s$/) do |klass|
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


Given(/^"([^\"]*)" has a QOTD message with:$/) do |username, table|
  data = table.rows_hash
  data['type'] = 'Admin::Qotd'

  message = Factory(:admin_message, data)

  user = User.find_by_username(username)
  recipient = user.employments.first
  Factory(:admin_conversation, :admin_message => message, :recipient => recipient)

  # Sanity check
  user.admin_conversations.count.should be > 0
end

Given(/^"([^\"]*)" has a PR Tip message with:$/) do |username, table|
  data = table.rows_hash
  data['type'] = 'Admin::PrTip'
  Factory(:admin_message, data)
  Admin::PrTip.count.should be > 0
end

Then /^"([^\"]*)" should be subscribed to the holiday "([^\"]*)"$/ do |username, holidayname|
  holiday = Holiday.find_by_name!(holidayname)
  user = User.find_by_username!(username)
  holiday.restaurants.first.employees.should include(user)
end

