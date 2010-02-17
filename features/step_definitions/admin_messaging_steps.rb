def get_class_from_type(type = "")
  case type
  when 'PR Tip'
    'Admin::PrTip'
  when 'QOTD'
    'Admin::Qotd'
  when 'Announcement'
    'Admin::Announcement'
  end
end

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

Then(/^"([^\"]*)" should have (\d+) (QOTD|PR Tip|Announcement) messages?$/) do |username, num, type|
  type_string = get_class_from_type(type)
  user = User.find_by_username(username)
  user.admin_conversations(:conditions => {:type => type_string }).count.should == num.to_i
end


Given(/^"([^\"]*)" has a (QOTD|PR Tip|Announcement) message with:$/) do |username, type, table|
  data = table.rows_hash
  data['type'] = get_class_from_type(type)

  message = Factory(:admin_message, data)
  user = User.find_by_username(username)
  recipient = user.employments.first
  Factory(:admin_conversation, :admin_message => message, :recipient => recipient)

  # Sanity check
  user.admin_conversations.count.should be > 0
end
