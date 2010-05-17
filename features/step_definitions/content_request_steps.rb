When /^I create a new content request with subject "([^\"]*)" with criteria:$/ do |subject, table|
  visit new_admin_content_request_path
  fill_in :subject, :with => subject
  table.rows_hash.each do |field, value|
    select value, :from => field
  end
  click_button :submit  
end

Then /^the content request with subject "([^\"]*)" should have (\d+) restaurants?$/ do |subject, num|
  content_request = ContentRequest.find_by_subject(subject)
  content_request.restaurants.count.should == num.to_i
end

Then /^the last content request for "([^\"]*)" should be viewable by "([^\"]*)"$/ do |restaurantname,  employeename|
  restaurant = Restaurant.find_by_name(restaurantname)
  user = User.find_by_name(employeename)
  employment = restaurant.employments.find_by_employee_id(user.id)
  
  restaurant.content_requests.last.should be_viewable_by(employment)
end