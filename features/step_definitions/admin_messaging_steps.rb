Given(/^there are no QOTDs(?: in the system)?$/) do
  #noop
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
  User.find_by_username(username).admin_conversations.count.should == num.to_i
end


Given(/^"([^\"]*)" has a (QOTD) message with:$/) do |username, type, table|
  data = table.rows_hash
  message = Factory(:admin_message, data.merge(:type => 'Admin::Qotd'))
  user = User.find_by_username(username)
  recipient = user.employments.first
  Factory(:admin_conversation, :admin_message => message, :recipient => recipient)

  # Sanity check
  user.admin_conversations.count.should be > 0
end
