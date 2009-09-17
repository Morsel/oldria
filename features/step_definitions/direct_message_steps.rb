Given /^"([^\"]*)" has ([0-9]+) direct messages? from "([^\"]*)"$/ do |receiver, num, sender|
  receiving_user = User.find_by_username(receiver)
  sending_user = User.find_by_username(sender)
  num.to_i.times do
    Factory.create(:direct_message, :sender => sending_user, :receiver => receiving_user)
  end
end

When /^I send a direct message to "([^\"]*)" with:$/ do |username, table|
  visit new_user_direct_message_path(:user_id => User.find_by_username(username).to_param)
  message_date = table.hashes.first
  fill_in :direct_message_title, :with => message_date[:title]
  fill_in :direct_message_body,  :with => message_date[:body]
  click_button "Send"
end

Then /^I should see a message from "([^\"]*)"$/ do |username|
  response.should have_selector(".direct_message") do |message|
    message.should contain(username)
  end
end

Then /^I should see my message to "([^\"]*)"$/ do |username|
  response.should have_selector(".sent_message") do |message|
    message.should contain(username)
  end
end


Then /^"([^\"]*)" should have ([0-9]+) direct message$/ do |username, num|
  User.find_by_username(username).direct_messages.count.should == num.to_i
end
