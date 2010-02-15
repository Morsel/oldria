Given(/^there are no QOTDs(?: in the system)?$/) do
  #noop
end

When(/^I create a new QOTD with:$/)do |table|
  data = table.rows_hash
  visit new_admin_qotd_path
  fill_in 'Message', :with => data['Message']
  click_button :submit
end

Then(/^I should see list of QOTDs$/) do
  response.should have_selector('table')
end

Then(/^"([^\"]*)" should have (\d+) QOTD messages?$/) do |username, num|
  User.find_by_username(username).admin_conversations.count.should == num.to_i
end
