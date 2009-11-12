Given /^I have just created a restaurant named "([^\"]*)"$/ do |restaurantname|
  visit new_restaurant_url
  fill_in "Name", :with => restaurantname
  click_button :submit
end

Given /^a restaurant role named "([^\"]*)"$/ do |name|
  Factory(:restaurant_role, :name => name)
end

Given /^I have added "([^\"]*)" to that restaurant$/ do |email|
  click_link "Add employee"
  fill_in "Employee Email", :with => email
  click_button "Submit"
  click_button "Yes"
end

When /^I follow the edit role link for "([^\"]*)"$/ do |employee_name|
  user_id = User.find_by_name(employee_name).id
  click_link "edit", :within => "user_#{user_id}"
end

When /^I confirm the employee$/ do
  click_button "Yes"
end


Then /^"([^\"]*)" should be the account manager for "([^\"]*)"$/ do |username, restaurantname|
  user = User.find_by_username!(username)
  Restaurant.find_by_name(restaurantname).manager.should == user
end

Then /^"([^\"]*)" should be in the "([^\"]*)" metropolitan area$/ do |restaurantname, metro|
  area = MetropolitanArea.find_by_name!(metro)
  Restaurant.find_by_name(restaurantname).metropolitan_area.should == area
end

Then /^"([^\"]*)" should have "([^\"]*)" cuisine$/ do |restaurantname, cuisinename|
  cuisine = Cuisine.find_by_name!(cuisinename)
  Restaurant.find_by_name(restaurantname).cuisine.should == cuisine
end

Then /^"([^\"]*)" should(?: only)? have ([0-9]+) employees?$/ do |restaurantname, num|
  Restaurant.find_by_name(restaurantname).employees.count.should == num.to_i
end

Then /^"([^\"]*)" should be a "([^\"]*)" at "([^\"]*)"$/ do |name, rolename, restaurantname|
  restaurant = Restaurant.find_by_name(restaurantname)
  user = User.find_by_name(name)
  employment = Employment.first(:conditions => { :restaurant_id => restaurant.id, :employee_id => user.id })
  employment.restaurant_role.should_not be_nil
  employment.restaurant_role.name.should eql(rolename)
end
