Given(/^there are no (?:QOTDs|Admin Messages)(?: in the system)?$/) do
  Admin::Message.destroy_all
end

When(/^I create a new QOTD with:$/)do |table|
  data = table.rows_hash
  visit new_admin_qotd_path
  fill_in 'Message', :with => data['Message']
  click_button :submit
end

Then(/^I should see list of (QOTD|Announcement)s$/) do |klass|
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
  User.find_by_username(username).pr_tips.count.should > 0
end