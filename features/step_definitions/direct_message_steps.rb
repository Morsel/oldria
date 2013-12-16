def fill_in_form_with_data_hash(data_hash)
  fill_in 'direct_message_body', :with => data_hash[:body]
  click_button "Send"
end

Given /^"([^\"]*)" has ([0-9]+) direct messages? from "([^\"]*)"$/ do |receiver, num, sender|
  receiving_user = User.find_by_username(receiver)
  sending_user = User.find_by_username(sender)
  num.to_i.times do
    Factory.create(:direct_message, :sender => sending_user, :receiver => receiving_user)
  end
end

When /^I send a direct message to "([^\"]*)" with:$/ do |username, table|
  visit new_user_direct_message_path(:user_id => User.find_by_username(username).to_param)
  fill_in_form_with_data_hash table.hashes.first
end

When /^I send an admin direct message to "([^\"]*)" with:$/ do |username, table|
  visit new_admin_direct_message_path
  #select username, :from => "To"
  #fill_in_form_with_data_hash table.hashes.first
end

Then /^"([^\"]*)" should have an admin message with body: ?"([^\"]*)"$/ do |username, body|
  message = User.find_by_username(username).direct_messages.first
  # message.body.should == body
  # message.should be_from_admin
end


Then /^I should see a message from "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  page.should have_css(".direct_message") do |message|
    message.should contain(user.name)
  end
end

Then /^I should see my message to "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  page.should have_css(".sent_message") do |message|
    message.should contain(user.name)
  end
end

Then /^"([^\"]*)" should have ([0-9]+) direct message$/ do |username, num|
  User.find_by_username(username).direct_messages.count.should == num.to_i
end

Given /^"([^\"]*)" prefers to receive direct message alerts$/ do |username|
  user = User.find_by_username!(username)
  user.write_preference(:receive_email_notifications, true)
  user.save
end

Given /^"([^\"]*)" prefers to not receive direct message alerts$/ do |username|
  user = User.find_by_username!(username)
  user.write_preference(:receive_email_notifications, false)
  user.save
end

