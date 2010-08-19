def fill_in_fields_for_table(table)
  table.rows_hash.each do |field, value|
    if field == "Dates"
      dates = value.split(/ ?to ?/, 2)
      fill_in "Date started", :with => Date.parse(dates.first)
      fill_in "Date ended", :with => Date.parse(dates.last)
    else
      fill_in field, :with => value
    end
  end
end

When(/^I add a restaurant to my profile with:$/) do |table|
  visit '/profile/edit'

  within '.culinary_jobs' do
    fill_in_fields_for_table(table)
  end

  click_button "Save"
end

When(/^I add a nonculinary job to my profile with:$/) do |table|
  visit '/profile/edit'

  within '.nonculinary_jobs' do
    fill_in_fields_for_table(table)
  end

  click_button "Save"
end


When(/^I add an award to my profile with:$/) do |table|
  visit '/profile/edit'

  within '.awards' do
    fill_in_fields_for_table(table)
  end

  click_button "Save"
end

Then(/^I should have (\d+) restaurants? on my profile$/) do |num|
  @current_user.profile.culinary_jobs.count.should == num.to_i
end

Then(/^I should have (\d+) nonculinary jobs? on my profile$/) do |num|
  @current_user.profile.nonculinary_jobs.count.should == num.to_i
end

Then(/^I should have (\d+) awards? on my profile$/) do |num|
  @current_user.profile.awards.count.should == num.to_i
end

Then(/^I should see "([^"]*)" on my profile page$/) do |text|
  visit profile_path(@current_user.username)
  Then %Q{I should see "#{text}"}
end
