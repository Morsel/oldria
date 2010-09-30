Given /^a restaurant named "([^\"]*)" with the following employees:$/ do |restaurantname, table|
  restaurant = Restaurant.find_by_name(restaurantname) || Factory(:restaurant, :name => restaurantname)
  table.hashes.each do |userhash|
    role = RestaurantRole.find_or_create_by_name(userhash['role'])
    # subjectmatters = userhash.delete('subject matters')
    #   subjects = nil
    userhash.delete('role')

    subjectmatters = []

    if subjects = userhash.delete('subject matters')
      subjects.split(",").each do |subject|
        subjectmatters << Factory(:subject_matter, :name => subject.strip)
      end
    end

    user = Factory(:user, userhash)

    restaurant.employments.build(:employee => user, :restaurant_role => role, :subject_matters => subjectmatters)

  end
  restaurant.manager = restaurant.employees.first
  restaurant.save!
  restaurant
end

Given /^a restaurant named "([^\"]*)" with manager "([^\"]*)"$/ do |name, username|
  user = Factory(:user, :username => username, :email => "#{username}@testsite.com")
  restaurant = Factory(:managed_restaurant, :name => name, :manager => user)
end

Given /^"([^"]*)" is a manager for "([^"]*)"$/ do |username, restaurantname|
  user = User.find_by_username!(username)
  restaurant = Restaurant.find_by_name!(restaurantname)

  employment = restaurant.employments.find_by_employee_id(user.id)
  employment.update_attribute(:omniscient, true)
end


Given /^"([^\"]*)" is the account manager for "([^\"]*)"$/ do |username, restaurantname|
  user = User.find_by_username!(username)
  restaurant = Restaurant.find_by_name!(restaurantname)
  restaurant.manager = user
  restaurant.save
end

Given /^I am an employee of "([^\"]*)"$/ do |restaurantname|
  restaurant = Restaurant.find_by_name(restaurantname)
  visit restaurant_employees_path(restaurant)
  click_link "Add employee"
  fill_in "Employee Email", :with => current_user.email
  click_button "Submit"
  click_button "Yes"
end

Given /^"([^\"]*)" restaurant is in the "([^\"]*)" metro region$/ do |restaurantname, metroregion|
  restaurant = Restaurant.find_by_name(restaurantname)
  metro = Factory(:metropolitan_area, :name => metroregion)
  restaurant.metropolitan_area = metro
  restaurant.save!
end

Given /^I have just created a restaurant named "([^\"]*)"$/ do |restaurantname|
  @restaurant = Factory(:restaurant, :name => restaurantname, :manager => @current_user)
  visit restaurant_employees_path(@restaurant)
end

Given /^the restaurant "([^\"]*)" is in the region "([^\"]*)"$/ do |restaurantname, regionname|
  region = JamesBeardRegion.find_by_name(regionname)
  region ||= Factory(:james_beard_region, :name => regionname)
  restaurant = Restaurant.find_by_name!(restaurantname)
  restaurant.james_beard_region = region
  restaurant.save!
end

Given /^a subject matter "([^\"]*)"$/ do |name|
  Factory(:subject_matter, :name => name)
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
  click_link_within "#user_#{user_id}", "edit"
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
  employment = Employment.last(:conditions => { :restaurant_id => restaurant.id, :employee_id => user.id })
  employment.restaurant_role.should_not be_nil
  employment.restaurant_role.name.should eql(rolename)
end

Then /^"([^\"]*)" should be responsible for "([^\"]*)" at "([^\"]*)"$/ do |name, subject, restaurantname|
  restaurant = Restaurant.find_by_name!(restaurantname)
  user = User.find_by_name(name)
  subject_matter = SubjectMatter.find_by_name!(subject)
  employment = Employment.last(:conditions => { :restaurant_id => restaurant.id, :employee_id => user.id })
  employment.subject_matters.should_not be_blank
  employment.subject_matters.should include(subject_matter)
end

Then /^"([^\"]*)" should have a primary employment$/ do |username|
  User.find_by_username(username).primary_employment.should_not be_nil
end

When /^I remove optional information from the restaurant$/ do
  @restaurant.update_attributes(:twitter_username => nil,
      :facebook_page => nil, :management_company_name => nil,
      :management_company_website => nil)
end

Then /^I do not see a section for "([^\"]*)"$/ do |dom_id|
  response.should_not have_tag("##{dom_id}")
end

Then /^I see the uploaded restaurant photo$/ do
  response.should have_selector("img.restaurant_photo")
  response.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.photos.last.id}/medium/bourgeoispig.jpg")
end

Then /^I see the restaurant logo$/ do
  response.should have_selector("img#restaurant_logo")
  response.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.reload.logo.id}/medium/bourgeoispig_logo.gif")
end

When /^I select the (\d+)(st|nd|th) photo as the primary photo$/ do |photo_order, ordinal|
  choose("restaurant_primary_photo_id_#{@restaurant.reload.photos[photo_order.to_i-1].id}")
end

When /^I see the (\d+)(st|nd|th) photo selected as the primary photo$/ do |photo_order, ordinal|
  response.should have_selector("input", :type => "radio", :value => @restaurant.reload.photos[photo_order.to_i - 1].id.to_s, :checked => "checked")
end

Then /^I should see a menu with the name "([^\"]*)" and change frequency "([^\"]*)" and uploaded at date "([^\"]*)"$/ do |name, change_frequency, date|
  response.should have_selector(".menu_name", :content => name)
  response.should have_selector(".menu_change_frequency", :content => change_frequency)
  response.should have_selector(".menu_date", :content => Chronic.parse(date).to_s(:standard))
end
Then /^I should see a link to download the uploaded menu pdf "([^\"]*)"$/ do |file_name|
  response.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/attachments/#{@restaurant.reload.menus.last.id}/#{file_name}")
end
When /^I delete the menu with the name "([^"]*)"$/ do |name|
  menu = Menu.find_by_name(name)
  click_link_within("#menu_#{menu.id}", "Remove")
end
Then /^I should not have a menu with the name "([^"]*)" and change frequency "([^"]*)"$/ do |name, change_frequency|
  Menu.first(:conditions => {:name => name, :change_frequency => change_frequency}).should be_nil
end
Then /^I should have a menu with the name "([^"]*)" and change frequency "([^"]*)"$/ do |name, change_frequency|
  Menu.first(:conditions => {:name => name, :change_frequency => change_frequency}).should_not be_nil
end
Then /^I should not see any menus$/ do
  response.should_not have_selector("table#menus tr")
end
Then /^I should see an error message$/ do
  response.should have_selector("#errorExplanation")
end
