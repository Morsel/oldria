Given /^there is a QOTD asking "([^\"]*)"$/ do |text|
  @qotd = FactoryGirl.create(:qotd, :message => text)
end

Given /^there is a Trend Question "([^\"]*)"$/ do |text|
  subject, body = text.split(": ")
  @trend_question = FactoryGirl.create(:trend_question, :subject => subject, :body => body)
end

Given /^that QOTD was sent to "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  FactoryGirl.create(:admin_conversation, :admin_message => @qotd, :recipient => user)
end

Given /^that Trend Question was sent to "([^\"]*)"$/ do |restaurantname|
  FactoryGirl.create(:admin_discussion, :discussionable => @trend_question, :restaurant => Restaurant.find_by_name(restaurantname) )
end

Given /^that QOTD has the following answers:$/ do |table|
  @qotd ||= Admin::Qotd.last
  table.rows_hash.each do |name, response|
    # create the user
    user = FactoryGirl.create(:user, :name => name)
    employment = FactoryGirl.create(:employment, :employee => user)

    # Add as recipients to QOTD
    conversation = @qotd.admin_conversations.create(:recipient_id => employment.id)

    # Add the comment
    conversation.comments.create(:user_id => user.id, :comment => response)
  end
end

Given /^that QOTD is featured on the soapbox$/ do
  @soapbox_entry = FactoryGirl.create(:soapbox_entry, :featured_item => @qotd)
  @soapbox_entry.reload
  @soapbox_entry.update_attributes("featured_item_type" => "Admin::Qotd")
end

Given /^that Trend Question is featured on the soapbox$/ do
  @soapbox_entry = FactoryGirl.create(:soapbox_entry, :featured_item => @trend_question)
end

When /^I create a new soapbox entry for that QOTD with:$/ do |table|
  visit new_admin_soapbox_entry_path(:qotd_id => @qotd.to_param)

  # table.rows_hash.each do |field, value|
  #   if field == "Daily feature"
  #     #check field
  #   elsif field == "Published at"
  #     select_date field, :with => value
  #   else
  #     fill_in field, :with => value
  #   end
  # end

  #click_button "Save"
end

When /^I create a new soapbox entry for that Trend Question with:$/ do |table|
  visit new_admin_soapbox_entry_path(:trend_question_id => @trend_question.to_param)

  # table.rows_hash.each do |field, value|
  #   if field == "Daily feature"
  #     check field
  #   elsif field == "Published at"
  #     select_date field, :with => value
  #   else
  #     fill_in field, :with => value
  #   end
  # end

  # click_button "Save"
end

When /^I create a new soapbox page with:$/ do |table|
  visit new_admin_soapbox_page_path
  fill_in_form(table.rows_hash)
  #click_button "Save"
end

When /^I follow the corresponding soapbox entry link$/ do
  visit soapbox_soapbox_entry_path(:id => @soapbox_entry.to_param)
end

Then /^there should be (\d+) QOTDs? on the soapbox front burner page$/ do |num|
  visit url_for(:controller => "soapbox/soapbox_entries", :action => "index")
  SoapboxEntry.qotd.published.count == num.to_i
end

Then /^I see a navigation link for "([^\"]*)"$/ do |header_name|
  within "#restaurant_features" do
    page.should have_link(header_name)
  end
end

Then /^I do not see a navigation link for "([^\"]*)"$/ do |header_name|
  within "#restaurant_features" do
    page.should_not have_link(header_name)
  end
end

Then /^I see a page header for "([^\"]*)" with "([^\"]*)"$/ do |page_name, tags|
  page_obj = RestaurantFeaturePage.find_by_name(page_name)
  within ".feature_page_header" do
    page.should have_content(page_name)
  end
  tags.split(",").each do |tag|
    within "##{dom_id(page_obj)} .feature" do
      page.should have_content(tag.strip)
    end
  end
end

Then /^I do not see a page header for "([^\"]*)"$/ do |page_name|
  within ".feature_page_header" do
    page.should_not have_content(page_name)
  end
end

Then /^I should see an accolades section$/ do
  #page.should have_css(".accolades")
end

Then /^I should not see an accolades section$/ do
  page.should_not have_css(".accolades")
end

Then /^I should see an employee named "([^\"]*)"$/ do |name|
  page.should contain(name)
end

Then /^I should see the employees in the order "([^"]*)"$/ do |employee_names|
  expected_names = tableish(".employment", "h3")
  expected_names = expected_names.flatten.map { |n| n.gsub(",", "") }
  expected_names == employee_names.split(",").map(&:strip)
end

When /^that "([^\"]*)" (has|does not have) a premium account$/ do |restaurant_name, toggle|
  restaurant = Restaurant.find_by_name(restaurant_name)
  if toggle == "has"
    restaurant.subscription = FactoryGirl.create(:subscription)
  else
    restaurant.subscription = nil
  end
  restaurant.save!
end

Then /^I see an employee named "([^"]*)" with a link$/ do |username|
  user = User.find_by_username(username)
  # within ".employments" do
  #   page.should have_link(user.name)
  # end
end

Then /^I see an employee named "([^"]*)" without a link$/ do |username|
  user = User.find_by_username(username)
  # within ".employments" do
  #   page.should have_content(user.name)
  #   page.should_not have_link(user.name)
  # end
end

Then /^I should see the heading "([^\"]*)"$/ do |text|
  # within "#page-title h1" do
  #   page.should have_content(text)
  # end
end

