Given /^a restaurant named "([^\"]*)" with the following employees:$/ do |restaurantname, table|
  restaurant = Restaurant.find_by_name(restaurantname) || FactoryGirl.build(:restaurant, :name => restaurantname, :manager => nil)
  
  table.hashes.each do |row|
    role = RestaurantRole.find_or_create_by_name(row.delete('role'))
    
    subjectmatters = []
    if subjects = row.delete('subject matters')
      subjects.split(",").each do |subject|
        subjectmatters << FactoryGirl.create(:subject_matter, :name => subject.strip)
      end
    end

    user = FactoryGirl.create(:user, row)
    
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
  user = FactoryGirl.create(:user, :username => username, :email => "#{username}@testsite.com")
  restaurant = FactoryGirl.create(:restaurant, :name => name, :manager => user)
end

Given /^"([^"]*)" is a manager for "([^"]*)"$/ do |username, restaurantname|
  #BraintreeConnector.stubs(:update_customer)
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

Given /^I am an employee of "([^\"]*)" with role "([^\"]*)"$/ do |restaurant_name, role_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  role = RestaurantRole.find_or_create_by_name(role_name)
  FactoryGirl.create(:employment, :employee => User.last, :restaurant => restaurant, :restaurant_role => role)
end

Given /^"([^\"]*)" restaurant is in the "([^\"]*)" metro region$/ do |restaurantname, metroregion|
  restaurant = Restaurant.find_by_name(restaurantname)
  metro = FactoryGirl.create(:metropolitan_area, :name => metroregion)
  restaurant.metropolitan_area = metro
  restaurant.save!
end

Given /^I have just created a restaurant named "([^\"]*)"$/ do |restaurantname|
  @restaurant = FactoryGirl.create(:restaurant, :name => restaurantname, :manager => @current_user)
  visit bulk_edit_restaurant_employees_path(@restaurant)
end

Given /^the restaurant "([^\"]*)" is in the region "([^\"]*)"$/ do |restaurantname, regionname|
  region = JamesBeardRegion.find_by_name(regionname)
  region ||= FactoryGirl.create(:james_beard_region, :name => regionname)
  restaurant = Restaurant.find_by_name!(restaurantname)
  restaurant.james_beard_region = region
  restaurant.save!
end

Given /^a subject matter "([^\"]*)"$/ do |name|
  FactoryGirl.create(:subject_matter, :name => name)
end

Given /^a restaurant role named "([^\"]*)"$/ do |name|
  FactoryGirl.create(:restaurant_role, :name => name)
end

Given /^I have added "([^\"]*)" to that restaurant$/ do |email|
  # click_link "Add employee"
  # fill_in "Employee email", :with => email
  # click_button "Submit" # search for user
  # click_button "Yes" # confirm selected user
  # click_button "Submit" # save default roles/responsibilities
end

When /^I follow the edit role link for "([^\"]*)"$/ do |employee_name|
  #user_id = User.find_by_name(employee_name).id
  # within "#user_#{user_id}" do
  #   click_link "Edit"
  # end
end

When /^I confirm the employee$/ do
  #click_button "Yes"
end

Then /^"([^\"]*)" should be the account manager for "([^\"]*)"$/ do |username, restaurantname|
  user = User.find_by_username!(username)
  Restaurant.find_by_name(restaurantname).manager == user
end

Then /^"([^\"]*)" should be in the "([^\"]*)" metropolitan area$/ do |restaurantname, metro|
  area = MetropolitanArea.find_by_name(metro)
  Restaurant.find_by_name(restaurantname).metropolitan_area == area
end

Then /^"([^\"]*)" should have "([^\"]*)" cuisine$/ do |restaurantname, cuisinename|
  cuisine = Cuisine.find_by_name(cuisinename)
  Restaurant.find_by_name(restaurantname).cuisine == cuisine
end

Then /^"([^\"]*)" should(?: only)? have ([0-9]+) employees?$/ do |restaurantname, num|
  Restaurant.find_by_name(restaurantname).employees.count == num.to_i
end

Then /^"([^\"]*)" should be a "([^\"]*)" at "([^\"]*)"$/ do |name, rolename, restaurantname|
  restaurant = Restaurant.find_by_name(restaurantname)
  user = User.find_by_name(name)
  employment = Employment.last(:conditions => { :restaurant_id => restaurant.id, :employee_id => user.id })
  #employment.restaurant_role.should_not be_nil
  #employment.restaurant_role.name.should eql(rolename)
end

Then /^"([^\"]*)" should be responsible for "([^\"]*)" at "([^\"]*)"$/ do |name, subject, restaurantname|
  restaurant = Restaurant.find_by_name!(restaurantname)
  user = User.find_by_name(name)
  subject_matter = SubjectMatter.find_by_name!(subject)
  employment = Employment.last(:conditions => { :restaurant_id => restaurant.id, :employee_id => user.id })
  #employment.subject_matters.should_not be_blank
  #employment.subject_matters.should include(subject_matter)
end

Then /^"([^\"]*)" should have a primary employment$/ do |username|
  #User.find_by_username(username).primary_employment.should_not be_nil
end

Then /^"([^\"]*)" should have a primary employment with role "([^\"]*)"$/ do |username, rolename|
  employment = User.find_by_username(username).primary_employment
  role = RestaurantRole.find_by_name(rolename)
  employment.should_not be_nil
  employment.restaurant_role.should == role
end

When /^I remove optional information from the restaurant$/ do
  @restaurant.update_attributes(:twitter_handle => nil,
                                :facebook_page_url => nil,
                                :management_company_name => nil,
                                :management_company_website => nil)
end

Then /^I do not see a section for "([^\"]*)"$/ do |dom_id|
  page.should_not have_css("##{dom_id}")
end

Then /^I see the uploaded restaurant photo$/ do
  #page.should have_css("img.restaurant_photo")
  #page.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.photos.last.id}/medium/bourgeoispig.jpg")
end

When /^I should see the uploaded restaurant photo credit$/ do
 # page.should have_selector(".restaurant_photo_credit", :text => @restaurant.photos.last.credit)
end

Then /^I see the restaurant logo$/ do
  # @restaurant = Restaurant.find(@restaurant.id)
  # filename = "http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.reload.logo.id}/medium/bourgeoispig_logo.gif"
  # page.should have_css("img#restaurant_logo_image[src*=\"#{filename}\"]")
end

Then /^I should not see the restaurant logo$/ do
  filename = "avatar_restaurant.gif"
  #page.should have_css("img#restaurant_logo_image[src*=\"#{filename}\"]")
end


When /^I select the (\d+)(st|nd|th) photo as the primary photo$/ do |photo_order, ordinal|
  #choose("restaurant_primary_photo_id_#{@restaurant.reload.photos[photo_order.to_i-1].id}")
end

When /^I see the (\d+)(st|nd|th) photo selected as the primary photo$/ do |photo_order, ordinal|
  #page.should have_css("input", :type => "radio", :value => @restaurant.reload.photos[photo_order.to_i - 1].id.to_s, :checked => "checked")
end

Then /^I should see that photo$/ do
  #page.should have_css("img", :src => @restaurant.reload.photos.last.attachment.url(:medium_photo))
end

Then /^I should see a menu with the name "([^\"]*)" and change frequency "([^\"]*)" and uploaded at date "([^\"]*)"$/ do |name, change_frequency, date|
  #page.should have_selector(".menu_name", :text => name)
  #page.should have_selector(".menu_change_frequency", :text => change_frequency)
  #page.should have_selector(".menu_date", :text => Chronic.parse(date).to_s(:standard))
end

Then /^I should see a link to download the uploaded menu pdf "([^\"]*)"$/ do |file_name|
  #page.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/attachments/#{@restaurant.reload.menus.last.id}/#{file_name}")
end

When /^I delete the menu with the name "([^"]*)"$/ do |name|
  menu = Menu.find_by_name(name)
  # within "#menu_#{menu.id}" do
  #   page.should have_link("Remove")
  #   click_link("Remove")
  # end
end

Then /^I should not have a menu with the name "([^"]*)" and change frequency "([^"]*)"$/ do |name, change_frequency|
  # page.should have_content("The menu was deleted")
  # Menu.first(:conditions => {:name => name, :change_frequency => change_frequency}).should be_nil
end

Then /^I should have a menu with the name "([^"]*)" and change frequency "([^"]*)"$/ do |name, change_frequency|
  # within ".menu_name" do
  #   page.should have_content(name)
  # end
  # within ".menu_change_frequency" do
  #   page.should have_content(change_frequency)
  # end
  #Menu.first(:conditions => {:name => name, :change_frequency => change_frequency}).should_not be_nil
end

Then /^I should not see any menus$/ do
  page.should_not have_css("table#menus tr")
end

Then /^I should see an error message$/ do
  #page.should have_css("#errorExplanation")
end

Then /^I should see a flash error message$/ do
 # page.should have_css("#flash_error")
end

Given /^"([^\"]*)" is an employee of "([^\"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  #user.restaurants << restaurant
end

Given /^"([^"]*)" is an employee of "([^"]*)" with public position (\d+)$/ do |username, restaurant_name, position|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  user.restaurants << restaurant unless user.restaurants.include? restaurant
  restaurant.employments.find_by_employee_id(user.id).update_attributes(
      :position => position, :public_profile => true)
end

Then /^I should have a photo with the file "([^"]*)"$/ do |filename|
  #page.should have_css("img.restaurant_photo[src*=\"#{filename}\"]")
end

Then /^I should not have a photo with the file "([^"]*)"$/ do |filename|
  #page.should_not have_css("img.restaurant_photo[src*=\"#{filename}\"]")
end

When /^I remove the restaurant photo with the file "([^"]*)"$/ do |filename|
  photo = @restaurant.photos.find_by_attachment_file_name(filename)
  # within "#photo_#{photo.id}" do
  #   click_link("Remove")
  # end
end

When /^I remove the restaurant logo$/ do
  # within "#delete-logo" do
  #   click_link("Remove")
  # end
end

Then /^I see no restaurant photos$/ do
 # page.should_not have_css("img.restaurant_photo")
end

When /^I click to make "([^"]*)" public$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  within "##{dom_id(employment)}" do
    click_link("Click to make public")
  end
end

Then /^I should see that "([^"]*)" is public$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  page.should have_selector("##{dom_id(employment)} .public", :text => "will be displayed")
end

When /^I click to make "([^\"]*)" private$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  # within "##{dom_id(employment)}" do
  #   click_link("Click to hide")
  # end
end

Then /^I should see that "([^\"]*)" is private$/ do |username|
  user = User.find_by_username(username)
  employment = user.employments.first
  #page.should have_selector("##{dom_id(employment)} .private", :text => "will not be displayed")
end

When /^I should not see an employee listing for "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  #page.should_not have_css("##{dom_id(user)}")
end

Given /^the following a la minute questions:$/ do |table|
  table.rows.each do |table|
    ALaMinuteQuestion.create!(:question => table.first, :kind => "restaurant")
  end
end

Then /^I see a header for a la minute$/ do
  #page.should have_selector("h1", :text => "A La Minute Questions")
end

Then /^I see the text for each question$/ do
  ALaMinuteQuestion.all.each do |question|
    #page.should have_selector("#a_la_minute_questions .question", :text => question.question)
  end
end

Given /^"([^\"]*)" has answered "([^\"]*)" with "([^\"]*)"$/ do |restaurant_name, question, answer|
  @restaurant = Restaurant.find_by_name(restaurant_name)
  @question = ALaMinuteQuestion.find_by_question(question)
  @answer = ALaMinuteAnswer.create!(:answer => answer, :a_la_minute_question => @question,
      :responder => @restaurant)
end

Then /^I should see the answer "([^\"]*)"$/ do |answer_text|
 #page.should have_selector(".answer", :text => answer_text)
end

Given /^the user "([^\"]*)" is employed by "([^\"]*)"$/ do |username, restaurant_name|
  user = User.find_by_username(username)
  restaurant = Restaurant.find_by_name(restaurant_name)
  #FactoryGirl.create(:employment, :employee => user, :restaurant => restaurant)
end

Given /^I am logged in as an account manager for "([^\"]*)"$/ do |arg1|
  account_manager = FactoryGirl.create(:user, :username => 'account_manager',
      :password => 'account_manager')
  @restaurant.employees << account_manager
  # account_manager.reload.employments.find(:first,
  #     :conditions => {:restaurant_id => @restaurant.id}).update_attributes!(
  #         :omniscient => true)
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
  #FactoryGirl.create(:employment, :employee => user, :restaurant => restaurant, :omniscient => true)
end

Then /^I should view the dashboard$/ do
  page.should have_css("#dashboard.selected")
end

Given /^"([^"]*)" has answered the following A La Minute questions:$/ do |restaurant_name, table|
  @restaurant = Restaurant.find_by_name(restaurant_name)
  table.hashes.each do |row|
    # TODO this feels cludgy... there's probably a better way... refactor.
    question = ALaMinuteQuestion.find_by_question(row['question']) || FactoryGirl.create(:a_la_minute_question, :question => row['question'], :kind => "restaurant")
    answer_params = {:answer => row['answer'],
        :a_la_minute_question => question, :responder => @restaurant}
    answer_params[:created_at] = eval(row['created_at']) if row['created_at']
    answer_params[:updated_at] = eval(row['created_at']) if row['created_at']

    answer = FactoryGirl.create(:a_la_minute_answer, answer_params)
  end
end

Then /^I should see the question "([^"]*)" with the answer "([^"]*)"$/ do |question_text, answer_text|
  #page.should have_selector(".question", :text => question_text)
  #page.should have_selector(".answer", :text => answer_text)
end

Then /^I should not see the question "([^"]*)" with the answer "([^"]*)"$/ do |question_text, answer_text|
  page.should_not have_selector(".answer", answer_text)
end

Then /^I should not see the answer "([^"]*)"$/ do |answer_text|
  page.should_not have_selector(".answer", answer_text)
end

Then /^the listing for "([^\"]*)" should be premium$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  within "tr##{dom_id(restaurant)}" do
    page.should have_content("Premium")
  end
end

Then /^the listing for "([^\"]*)" should be complimentary$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  # within "tr##{dom_id(restaurant)}" do
  #   page.should have_content("Complimentary")
  # end
end

Then /^the listing for "([^\"]*)" should be basic$/ do |restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  # within "tr##{dom_id(restaurant)}" do
  #   page.should have_content("Basic")
  # end
end

Given /^I have created the following A La Minute Questions:$/ do |table|
  table.hashes.each do |row|
    question = FactoryGirl.create(:a_la_minute_question, row)
  end
end

Then /^I should see the following questions:$/ do |table|
  table.hashes.each do |row|
    question = ALaMinuteQuestion.find_by_question(row['question'])
    # within "#a_la_minute_questions" do
    #   page.should have_content(question.question)
    # end
  end
end

When /^I follow "([^"]*)" for "([^"]*)"$/ do |link, question_text|
  question = ALaMinuteQuestion.find_by_question(question_text)
  within "##{dom_id(question)}" do
    click_link link
  end
end

When /^I follow "([^"]*)" for the answer "([^"]*)"$/ do |link, answer_text|
  answer = ALaMinuteAnswer.find_by_answer(answer_text)
  # within "##{dom_id(answer)}" do
  #   click_link link
  # end
end

Then /^I should see the answer "([^"]*)" for "([^"]*)"$/ do |answer, name|
  responder = Restaurant.find_by_name(name)
  # within "#answers" do
  #   page.should have_content(answer)
  # end
end

When /^I should see that the restaurant has a basic account$/ do
  # within "#account_type" do
  #   page.should have_content("Basic")
  # end
end

Then /^I should see that the restaurant has a complimentary account$/ do
  # within "#account_type" do
  #   page.should have_content("Complimentary")
  # end
end

When /^I should see that the restaurant has a premium account$/ do
  # within "#account_type" do
  #   page.should have_content("Premium")
  # end
end

Given /^the restaurant "([^\"]*)" has a complimentary account$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  restaurant.subscription = FactoryGirl.create(:subscription, :payer => nil)
  restaurant.save!
end

When /^I delete the account manager for "([^\"]*)"$/ do |name|
  restaurant = Restaurant.find_by_name(name)
  # within "#user_#{restaurant.manager_id}" do
  #   click_link "Delete"
  # end
end

When /^I fill in a la minute question titled "([^\"]*)" with answer "([^\"]*)"$/ do |title, answer|
  question = ALaMinuteQuestion.find_by_question(title)
  When "I fill in \"a_la_minute_questions_#{question.id}_answer\" with \"#{answer}\""
end

Given /^a promotion type named "([^\"]*)"$/ do |name|
  FactoryGirl.create(:promotion_type, :name => name)
end

Given /^a menu item keyword "([^\"]*)" with category "([^\"]*)"$/ do |name, category|
  FactoryGirl.create(:otm_keyword, :name => name, :category => category)
end

Given /^the following menu items for "([^\"]*)":$/ do |restaurant_name, table|
  restaurant = Restaurant.find_by_name(restaurant_name)
  table.hashes.each do |row|
    FactoryGirl.create(:menu_item, row.merge(:restaurant => restaurant))
  end
end
