Given /^there is a QOTD asking "([^"]*)"$/ do |text|
  @qotd = Factory(:qotd, :message => text)
end

Given /^that QOTD has the following answers:$/ do |table|
  @qotd ||= Admin::Qotd.last
  table.rows_hash.each do |name, response|
    # create the user
    user = Factory(:user, :name => name)
    employment = Factory(:employment, :employee => user)

    # Add as recipients to QOTD
    conversation = @qotd.admin_conversations.create(:recipient_id => employment.id)

    # Add the comment
    conversation.comments.create(:user_id => user.id, :comment => response)

  end
end

When /^I create a new soapbox entry for that QOTD with:$/ do |table|
  visit new_admin_soapbox_entry_path(:qotd_id => @qotd.to_param)

  table.rows_hash.each do |field, value|
    fill_in field, :with => value
  end

  click_button "Save"
end

Then /^there should be (\d+) QOTDs? on the soapbox landing page$/ do |num|
  SoapboxEntry.count(:conditions => {:featured_item_type => 'Admin::Qotd'}).should == num.to_i
end

