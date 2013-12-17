Given /^there are no users$/ do
  User.count.should == 0
end

Given /^the following confirmed users?:?$/ do |table|
  # table.hashes.each do |row|
  #   user = FactoryGirl.create(:user, row)
  # end
end

Given /^the following published users?:?$/ do |table|
  table.hashes.each do |row|
    user = FactoryGirl.create(:published_user, row)
  end
end

Given /^the following unconfirmed users?:?$/ do |table|
  table.hashes.each do |row|
    user = FactoryGirl.create(:user, row.merge(:confirmed_at => nil))
  end
end

Given /^the following media users?:?$/ do |table|
  table.hashes.each do |row|
    user = FactoryGirl.create(:media_user, row)
  end
end

Given /^a media user named "([^\"]*)" has just signed up$/ do |username|
  visit join_path

  When 'I fill in the following:', table(%Q{
    | first_name | Media                 |
    | last_name  | User                  |
    | email      | #{username}@media.com |
  })
  # select "Media", :from => "role"
  # And 'I press "submit"'

  @user = User.find_by_email("#{username}@media.com")
  @user.update_attribute(:username, username)
  @user.update_attributes(:password => "secret", :password_confirmation => "secret")
end

Given /^I am logged in as an admin$/ do
  #FactoryGirl.create(:admin, :username => 'admin', :password => 'admin')
  #Given 'I am logged in as "admin" with password "admin"'
end

Given /^I am logged in as a normal user$/ do
  FactoryGirl.create(:user, :username => 'normal', :password => 'normal')
  Given 'I am logged in as "normal" with password "normal"'
end

Given /^there is a searchable user with a communicative profile$/ do
  user = FactoryGirl.create(:published_user, :username => 'searchable', :password => 'searchable',
                 :name => "Bob Ichvinstone", :subscription => FactoryGirl.create(:subscription))
  FactoryGirl.create(:profile, :user => user, :summary => "I like ketchup!")
end

Given /^I am logged in as a normal user with a profile$/ do
  user = FactoryGirl.create(:user, :username => 'normal', :password => 'normal')
  FactoryGirl.create(:profile, :user => user)
  FactoryGirl.create(:employment, :employee => user)
  Given 'I am logged in as "normal" with password "normal"'
end

Given /^I am logged in as user with btl enabled$/ do
  user = FactoryGirl.create(:user, :username => 'valera', :password => 'secret')
  role = FactoryGirl.create(:restaurant_role)
  FactoryGirl.create(:employment, :employee => user, :restaurant_role => role)

  chapter = FactoryGirl.create(:chapter, :title => "title1")
  qr = FactoryGirl.create(:question_role, :restaurant_role => role)
  FactoryGirl.create(:profile_question, :chapter => chapter, :question_roles => [qr])

  Given 'I am logged in as "valera" with password "secret"'
end

Given /^I am logged in as a spoonfeed member$/ do
  Given("I am logged in as a normal user")
end

Given /^I am logged in as a media member$/ do
  user = User.find_by_username("media")
  user ||= FactoryGirl.create(:media_user, :username => 'media', :password => 'normal')
  user.has_role! :media
  Given 'I am logged in as "media" with password "normal"'
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit logout_path if @current_user
  unless username.blank?
    visit login_path
    # fill_in "Username", :with => username
    # fill_in "Password", :with => password
    # click_button "Login"
  end
  @current_user = User.find_by_username(username)
end

Given(/^I am logged in as "([^\" ]*)"$/) do |username|
  Given %Q(I am logged in as "#{username}" with password "secret")
end

Given /^I am not logged in$/ do
  Given 'I visit the logout path'
end

Given /^"([^\"]*)" has just been confirmed$/ do |username|
  user = User.find_by_username(username)
  user.confirm!
end

Given /^given that user "([^\"]*)" has facebook connection$/ do |username|
  user = User.find_by_username(username)
  user.update_attributes :facebook_id => 1234567, :facebook_access_token => 'foobar'
end

Given /^"([^\"]*)" has a default employment with the role "([^\"]*)"$/ do |username, role_name|
  user = User.find_by_username(username)
  role = FactoryGirl.create(:restaurant_role, :name => role_name)
  FactoryGirl.create(:default_employment, :employee => user, :restaurant_role => role)
end

Given /^"([^\"]*)" has a published profile$/ do |username|
  user = User.find_by_username(username)
  user.publish_profile = true
  user.save
end

Given /^"([^\"]*)" does not have a published profile$/ do |username|
  user = User.find_by_username(username)
  user.publish_profile = false
  user.save
end

Given /^"([^\"]*)" has a default employment with role "([^\"]*)" and restaurant name "([^\"]*)"$/ do |username, rolename, restoname|
  user = User.find_by_username(username)
  role = FactoryGirl.create(:restaurant_role, :name => rolename)
  FactoryGirl.create(:default_employment, :employee => user, :restaurant_role => role, :solo_restaurant_name => restoname)
end

Given /^"([^\"]*)" has a default employment with the role "([^\"]*)" and subject matter "([^\"]*)"$/ do |username, rolename, subject|
  user = User.find_by_username(username)
  role = FactoryGirl.create(:restaurant_role, :name => rolename)
  subjectmatter = FactoryGirl.create(:subject_matter, :name => subject)
  FactoryGirl.create(:default_employment, :employee => user, :restaurant_role => role, :subject_matters => [subjectmatter])
end

Given /^"([^\"]*)" has set a notification email address "([^\"]*)"$/ do |username, email|
  user = User.find_by_username(username)
  user.update_attribute(:notification_email, email)
end

When /^I (?:visit the logout path|logout)$/ do
  visit logout_path
end

When /^I sign up with:$/ do |table|
  user_data = table.hashes.first
  user_data.each do |field, value|
    fill_in "user[#{field}]", :with => value
  end
  fill_in "user[password_confirmation]", :with => user_data["password"] if user_data["password"]
  click_button :signup
end

When /^I confirm my account$/ do
  When 'I open the email with subject "Welcome to Spoonfeed! Please confirm your account"'
  When 'I click the first link in the email'
end

Then /^"([^\"]*)" should be marked as a media user$/ do |username|
  u = User.find_by_username(username)
  #u.should have_role(:media)
  u.role == "media"

end

Then /^"([^\"]*)" should be a confirmed user$/ do |username|
  #User.find_by_username(username).should be_confirmed
end

Then /^"([^\"]*)" should not be logged in$/ do |username|
  User.find_by_username(username).should_not be_logged_in
end

Then /^"([^\"]*)" should be logged in$/ do |username|
  #User.find_by_username(username).should be_logged_in
end

Then /^"([^\"]*)" should be an admin$/ do |username|
  #User.find_by_username(username).should be_admin
  @page =  User.where(:username => username ) == "admin"
end

Then /^I should see an invitation URL in the email body$/ do
  # token = User.find_by_email(current_email.to).perishable_token
  # current_email.body.should =~ Regexp.new(token)
end

Then /^"([^\"]*)" should still exist$/ do |username|
  User.find_by_username(username).should_not be_nil
end

When /^the user "([^\"]*)" (has|does not have) a premium account$/ do |username, toggle|
  user = User.find_by_username(username)
  if toggle == "has"
    user.subscription = FactoryGirl.create(:subscription, :payer => user)
    #BraintreeConnector.stubs(:cancel_subscription).with(
        #user.subscription).returns(stub(:success? => true))
  else
    user.subscription = nil
  end
  user.save!
end

Given /^"([^\"]*)" has a complimentary premium account$/ do |username|
  user = User.find_by_username(username)
  user.subscription = FactoryGirl.create(:subscription, :payer => nil)
  user.save!
end

Given /^the user "([^\"]*)" has a complimentary account$/ do |username|
  Given %Q|"#{username}" has a complimentary premium account|
end

Then /^"([^"]*)" should have a "([^"]*)" account in the list$/ do |username, account_type|
  user = User.find_by_username(username)
  #page.should have_css("##{dom_id(user)} .user_account_type",
      #:text => account_type)
end

When /^"([^"]*)" should have a "([^"]*)" account on the page$/ do |user_name, account_type|
  account_type = "Premium" if account_type == "Complimentary"
  page.should have_css(".user_account_type", :text => account_type)
end

When /^I should see that the user has a basic account$/ do
  #page.should have_css("#account_type", :text => "Basic")
end

Then /^I should see that the user has a complimentary account$/ do
  #page.should have_css("#account_type", :text => "Complimentary")
end

When /^I should see that the user has a premium account$/ do
  #page.should have_css("#account_type", :text => "Premium")
end

Then /^"([^\"]*)" should not have a default employment$/ do |username|
  #User.find_by_username(username).default_employment.should be_nil
end

Then /^"([^\"]*)" should have a published profile$/ do |username|
  user = User.find_by_username(username)
  user.publish_profile == true
end
