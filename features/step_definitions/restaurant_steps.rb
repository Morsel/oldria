Given /^a restaurant named "([^\"]*)" with the following employees:$/ do |restaurantname, table|
  restaurant = Restaurant.find_by_name(restaurantname) || Factory.build(:restaurant, :name => restaurantname, :manager => nil)
  
  table.hashes.each do |row|
    role = RestaurantRole.find_or_create_by_name(row.delete('role'))
    
    subjectmatters = []
    if subjects = row.delete('subject matters')
      subjects.split(",").each do |subject|
        subjectmatters << Factory(:subject_matter, :name => subject.strip)
      end
    end

    user = Factory(:user, row)
    
    # New restaurant setup
    if restaurant.manager.present?
      restaurant.employments.build(:employee => user, :restaurant_role => role, :subject_matters => subjectmatters)
    else
      restaurant.manager = user
      restaurant.save
      restaurant.employments.first.update_attributes(:restaurant_role => role, :subject_matters => subjectmatters)
    end
  end

  restaurant.save!
  restaurant
end

Given /^a restaurant named "([^\"]*)" with manager "([^\"]*)"$/ do |name, username|
  user = Factory(:user, :username => username, :email => "#{username}@testsite.com")
  restaurant = Factory(:restaurant, :name => name, :manager => user)
end

Given /^"([^"]*)" is a manager for "([^"]*)"$/ do |username, restaurantname|
  BraintreeConnector.stubs(:update_customer)
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
  visit bulk_edit_restaurant_employees_path(restaurant)
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
  visit bulk_edit_restaurant_employees_path(@restaurant)
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
  click_button "Submit" # search for user
  click_button "Yes" # confirm selected user
  click_button "Submit" # save default roles/responsibilities
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

Then /^"([^\"]*)" should have a primary employment with role "([^\"]*)"$/ do |username, rolename|
  employment = User.find_by_username(username).primary_employment
  role = RestaurantRole.find_by_name(rolename)
  employment.should_not be_nil
  employment.restaurant_role.should == role
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

When /^I should see the uploaded restaurant photo credit$/ do
  response.should have_selector(".restaurant_photo_credit", :content => @restaurant.photos.last.credit)
end

Then /^I see the restaurant logo$/ do
  @restaurant = Restaurant.find(@restaurant.id)
  filename = "http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.reload.logo.id}/medium/bourgeoispig_logo.gif"
  response.should have_selector("img#restaurant_logo_image[src*=\"#{filename}\"]")
end

Then /^I should not see the restaurant logo$/ do
  filename = "avatar_restaurant.gif"
  response.should have_selector("img#restaurant_logo_image[src*=\"#{filename}\"]")
end


When /^I select the (\d+)(st|nd|th) photo as the primary photo$/ do |photo_order, ordinal|
  choose("restaurant_primary_photo_id_#{@restaurant.reload.photos[photo_order.to_i-1].id}")
end

When /^I see the (\d+)(st|nd|th) photo selected as the primary photo$/ do |photo_order, ordinal|
  response.should have_selector("input", :type => "radio", :value => @restaurant.reload.photos[photo_order.to_i - 1].id.to_s, :checked => "checked")
end

Then /^I should see that photo$/ do
  response.should have_selector("img", :src => @restaurant.reload.photos.last.attachment.url(:medium))
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

Then /^I should see a flash error message$/ do
  response.should have_selector("#flash_error")
end

Given /^"([^\"]*)" is an employee of "([^\"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  user.restaurants << restaurant
end

Given /^"([^"]*)" is an employee of "([^"]*)" with public position (\d+)$/ do |username, restaurant_name, position|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  user.restaurants << restaurant unless user.restaurants.include? restaurant
  restaurant.employments.find_by_employee_id(user.id).update_attributes(
      :position => position, :public_profile => true)
end

Then /^I should have a photo with the file "([^"]*)"$/ do |filename|
  response.should have_selector("img.restaurant_photo[src*=\"#{filename}\"]")
end

Then /^I should not have a photo with the file "([^"]*)"$/ do |filename|
  response.should_not have_selector("img.restaurant_photo[src*=\"#{filename}\"]")
end

When /^I remove the restaurant photo with the file "([^"]*)"$/ do |filename|
  photo = @restaurant.photos.find_by_attachment_file_name(filename)
  click_link_within("#photo_#{photo.id}", "Remove")
end

When /^I remove the restaurant logo$/ do
  click_link_within("#delete-logo", "Remove")
end

Then /^I see no restaurant photos$/ do
  response.should_not have_selector("img.restaurant_photo")
end

When /^I click to make "([^"]*)" public$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  click_link_within("##{dom_id(employment)}", "Click to make public")
end

Then /^I should see that "([^"]*)" is public$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  response.should have_selector("##{dom_id(employment)} .public", :content => "will be displayed")
end

When /^I click to make "([^\"]*)" private$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  click_link_within("##{dom_id(employment)}", "Click to hide")
end

Then /^I should see that "([^\"]*)" is private$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  response.should have_selector("##{dom_id(employment)} .private", :content => "will not be displayed")
end

When /^I should not see an employee listing for "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  response.should_not have_selector("##{dom_id(user)}")
end

Given /^the following a la minute questions:$/ do |table|
  table.rows.each do |table|
    ALaMinuteQuestion.create!(:question => table.first, :kind => "restaurant")
  end
end

Then /^I see a header for a la minute$/ do
  response.should have_selector("h1", :content => "A La Minute Questions")
end

Then /^I see the text for each question$/ do
  ALaMinuteQuestion.all.each do |question|
    response.should have_selector("#a_la_minute_questions .question", :content => question.question)
  end
end

Given /^"([^\"]*)" has answered "([^\"]*)" with "([^\"]*)"$/ do |restaurant_name, question, answer|
  @restaurant = Restaurant.find_by_name(restaurant_name)
  @question = ALaMinuteQuestion.find_by_question(question)
  @answer = ALaMinuteAnswer.create!(:answer => answer, :a_la_minute_question => @question,
      :responder => @restaurant)
end

Then /^I should see the answer "([^\"]*)"$/ do |answer_text|
  response.should have_selector(".answer", :content => answer_text)
end

Given /^the user "([^\"]*)" is employed by "([^\"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  Factory(:employment, :employee => user, :restaurant => restaurant)
end

Given /^I am logged in as an account manager for "([^\"]*)"$/ do |arg1|
  account_manager = Factory(:user, :username => 'account_manager',
      :password => 'account_manager')
  @restaurant.employees << account_manager
  account_manager.reload.employments.find(:first,
      :conditions => {:restaurant_id => @restaurant.id}).update_attributes!(
          :omniscient => true)
  Given 'I am logged in as "account_manager" with password "account_manager"'
end

Given /^the user "([^\"]*)" is not employed by "([^\"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.employees.delete(user)
end

Given /^the user "([^\"]*)" is an account manager for "([^\"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  Factory(:employment, :employee => user, :restaurant => restaurant, :omniscient => true)
end

Then /^I should view the dashboard$/ do
  response.should have_selector("#dashboard.selected")
end

Given /^"([^"]*)" has answered the following A La Minute questions:$/ do |restaurant_name, table|
  @restaurant = Restaurant.find_by_name(restaurant_name)
  table.hashes.each do |row|
    # TODO this feels cludgy... there's probably a better way... refactor.
    question = ALaMinuteQuestion.find_by_question(row['question']) || Factory(:a_la_minute_question, :question => row['question'], :kind => "restaurant")
    answer_params = {:answer => row['answer'],
        :a_la_minute_question => question, :responder => @restaurant,
        :show_as_public => row['public']}
    answer_params[:created_at] = eval(row['created_at']) if row['created_at']
    answer_params[:updated_at] = eval(row['created_at']) if row['created_at']

    answer = Factory(:a_la_minute_answer, answer_params)
  end
end

When /^I check "([^"]*)" for "([^"]*)"$/ do |label, question_text|
  question = ALaMinuteQuestion.find_by_question(question_text)
  within("##{dom_id(question)}") do |content|
    check("a_la_minute_questions[#{question.id}][show_as_public]")
  end
end

Then /^I should see the question "([^"]*)" with the answer "([^"]*)"$/ do |question_text, answer_text|
  answer = @restaurant.a_la_minute_answers.find_by_answer(answer_text)
  response.should have_selector(".question", :content => question_text)
  response.should have_selector(".answer", :content => answer_text)
end

Then /^I should not see the question "([^"]*)" with the answer "([^"]*)"$/ do |question_text, answer_text|
  response.should_not have_selector(".question", :content => question_text)
  response.should_not have_selector(".answer", :content => answer_text)
end

Then /^I should not see the answer "([^"]*)"$/ do |answer_text|
  response.should_not have_selector(".answer", :content => answer_text)
end

Then /^the listing for "([^\"]*)" should be premium$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  response.should have_selector("tr##{dom_id(restaurant)} td",
      :content => "Premium")
end

Then /^the listing for "([^\"]*)" should be complimentary$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  response.should have_selector("tr##{dom_id(restaurant)} td",
      :content => "Complimentary")
end

Then /^the listing for "([^\"]*)" should be basic$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  response.should have_selector("tr##{dom_id(restaurant)} td",
      :content => "Basic")
end

Given /^I have created the following A La Minute Questions:$/ do |table|
  table.hashes.each do |row|
    question = Factory(:a_la_minute_question, row)
  end
end

Then /^I should see the following questions:$/ do |table|
  table.hashes.each do |row|
    question = ALaMinuteQuestion.find_by_question(row['question'])
    response.should have_selector("#a_la_minute_questions td", :content => question.question)
  end
end

When /^I follow "([^"]*)" for "([^"]*)"$/ do |link, question_text|
  question = ALaMinuteQuestion.find_by_question(question_text)
  click_link_within("##{dom_id(question)}", link)
end

When /^I follow "([^"]*)" for the answer "([^"]*)"$/ do |link, answer_text|
  answer = ALaMinuteAnswer.find_by_answer(answer_text)
  click_link_within("##{dom_id(answer)}", link)
end

Then /^I should see the answer "([^"]*)" for "([^"]*)"$/ do |answer, name|
  responder = Restaurant.find_by_name(name) || User.find_by_name(name)
  response.should have_selector(".a_la_minute_answer", :content => answer)
end

When /^I should see that the restaurant has a basic account$/ do
  response.should have_selector("#account_type", :content => "Basic")
end

Then /^I should see that the restaurant has a complimentary account$/ do
  response.should have_selector("#account_type", :content => "Complimentary")
end

When /^I should see that the restaurant has a premium account$/ do
  response.should have_selector("#account_type", :content => "Premium")
end

Given /^the restaurant "([^\"]*)" has a complimentary account$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  restaurant.subscription = Factory(:subscription, :payer => nil)
  restaurant.save!
end

When /^I delete the account manager for "([^\"]*)"$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  click_link_within("#user_#{restaurant.manager_id}", "Delete")
end

When /^I fill in a la minute question titled "([^\"]*)" with answer "([^\"]*)"$/ do |title, answer|
  question = ALaMinuteQuestion.find_by_question(title)
  When "I fill in \"a_la_minute_questions_#{question.id}_answer\" with \"#{answer}\""
end

When /^I check a la minute question titled "([^\"]*)" as public$/ do |title|
  question = ALaMinuteQuestion.find_by_question(title)
  When "I check \"a_la_minute_questions_#{question.id}_show_as_public\""
end

Given /^a promotion type named "([^\"]*)"$/ do |name|
  Factory(:promotion_type, :name => name)
end
