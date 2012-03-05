def fill_in_fields_for_table(table)
  table.rows_hash.each do |field, value|
    if field == "Start date" || field == "Run date"
      select_date value, :from => field
    elsif field == 'Media Type' || field == 'Cuisine'
      select value, :from => field
    else
      fill_in field, :with => value
    end
  end
end

When(/^I add a profile item "([^"]*)" to my profile with:$/) do |profile_association, table|
  visit edit_user_profile_path(:user_id => @current_user.id)
  click_link_within ".#{profile_association.pluralize}", "Add"

  fill_in_fields_for_table(table)

  click_button "Save"
end

When(/^I add a restaurant to my profile with:$/) do |table|
  When %Q{I add a profile item "culinary_job" to my profile with:}, table
end

When(/^I add a nonculinary job to my profile with:$/) do |table|
  When %Q{I add a profile item "nonculinary_job" to my profile with:}, table
end

When(/^I add an award to my profile with:$/) do |table|
  When %Q{I add a profile item "award" to my profile with:}, table
end

When(/^I add an accolade to my profile with:$/) do |table|
  When %Q{I add a profile item "accolade" to my profile with:}, table
end

When /^I add a culinary school to my profile with:$/ do |table|
  When %Q{I add a profile item "culinary_school" to my profile with:}, table
end

When /^I add a cuisine to my profile with:$/ do |table|
  When %Q{I add a profile item "cuisine" to my profile with:}, table
end

Given /^a cuisine named "([^\"]*)"$/ do |cuisine|
  Factory(:cuisine, :name => cuisine)
end

Then /^I should have (\d+) culinary schools? on my profile$/ do |num|
  @current_user.profile.schools.count.should == num.to_i
end

When /^I add a nonculinary school to my profile with:$/ do |table|
  When %Q{I add a profile item "nonculinary_school" to my profile with:}, table
end

Then /^I should have (\d+) nonculinary school on my profile$/ do |num|
  @current_user.profile.nonculinary_schools.count.should == num.to_i
end

Then(/^I should have (\d+) restaurants? on my profile$/) do |num|
  @current_user.profile.culinary_jobs.count.should == num.to_i
end

Then(/^I should have (\d+) nonculinary jobs? on my profile$/) do |num|
  @current_user.profile.nonculinary_jobs.count.should == num.to_i
end

Then(/^I should have (\d+) accolades? on my profile$/) do |num|
  @current_user.profile.accolades.count.should == num.to_i
end

Then(/^I should have (\d+) awards? on my profile$/) do |num|
  @current_user.profile.awards.count.should == num.to_i
end

Then(/^I should have (\d+) cuisines? on my profile$/) do |num|
  @current_user.profile.cuisines.count.should == num.to_i
end
 
Then(/^I should see "([^"]*)" on my profile page$/) do |text|
  visit profile_path(@current_user.username)
  click_link "View Resume"
  Then %Q{I should see "#{text}"}
end
