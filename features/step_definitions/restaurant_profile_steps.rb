Given /^a restaurant named "([^\"]*)"$/ do |name|
  @restaurant = Factory(:restaurant, :name => name)
  employment = Factory(:employment, :restaurant => @restaurant)
  profile = Factory(:profile, :user => employment.employee)
  @restaurant.update_attributes!(:media_contact => employment.employee)
end

Given /^a premium restaurant named "([^\"]*)"$/ do |name|
  @restaurant = Factory(:restaurant, :name => name)
  @restaurant.subscription = Factory(:subscription)
  employment = Factory(:employment, :restaurant => @restaurant)
  profile = Factory(:profile, :user => employment.employee)
  @restaurant.update_attributes!(:media_contact => employment.employee)
end

Given /^that "([^\"]*)" has an employee "([^\"]*)"$/ do |restaurant_name, employee_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  employment = Factory(:employment, :restaurant => restaurant,
                       :employee => Factory(:user, :username => employee_name, :password => 'secret') )
end

Then /^I see the restaurant's name linked as "([^\"]*)"$/ do |name|
  response.should have_selector("#name a", :content => name)
end

Then /^I see the restaurant's description$/ do
  response.should have_selector("#description", :content => @restaurant.description)
end

When /^I see the address$/ do
  @restaurant.address_parts.each do |address_part|
    response.should have_selector(".address", :content => address_part)
  end
end

Then /^I see the phone number$/ do
  response.should have_selector("#phone_number", :content => @restaurant.phone_number)
end

Then /^I see the restaurant's website as a link$/ do
  response.should have_selector("#website a", :content => @restaurant.website,
      :href => @restaurant.website)
end

Then /^I see the restaurant's Twitter username$/ do
  response.should have_selector("#twitter_username a", :content => @restaurant.twitter_username,
      :href => "http://twitter.com/#{@restaurant.twitter_username}")
end

Then /^I see the restaurant's Facebook page$/ do
  response.should have_selector("#facebook_page a", :content => @restaurant.name,
      :href => @restaurant.facebook_page)
end

When /^I see the restaurant's hours$/ do
  response.should have_selector("#hours", :content => @restaurant.hours)
end

Then /^I see media contact name, phone, and email$/ do
  media_contact = @restaurant.media_contact
  response.should have_selector("#media_contact a",
      :content => media_contact.name,
      :href => profile_path(media_contact.username))
  response.should have_selector("#media_contact", :content => media_contact.phone_number)
  response.should have_selector("#media_contact a", :content => media_contact.email,
        :href => "mailto:#{media_contact.email}")
  response.should have_selector("#media_contact", :content => media_contact.email)
end

When /^I see media contact name and email, but no phone$/ do
  media_contact = @restaurant.media_contact
  response.should have_selector("#media_contact", :content => media_contact.name)
  response.should_not have_selector("#media_contact_phone")
end

Then /^I see the management company name as a link$/ do
  response.should have_selector("#management_company a", :content => @restaurant.management_company_name)
end

Given /^the restaurant has no media contact$/ do
  @restaurant.update_attributes(:media_contact => nil)
end

Given /^the restaurant media contact has no phone number$/ do
  @restaurant.media_contact.profile.update_attributes(:cellnumber => nil)
end

Given /^the restaurant media contact has a private phone number$/ do
  @restaurant.media_contact.profile.preferred_display_cell = "private"
  @restaurant.media_contact.profile.save!
end


Then /^I should not see media contact info$/ do
  response.should_not have_selector("#media_contact")
end

Given /^the restaurant has no website for its management company$/ do
  @restaurant.update_attributes(:management_company_website => nil)
end

When /^I see the management company name without a link$/ do
  response.should have_selector("#management_company", :content => @restaurant.management_company_name)
  response.should_not have_selector("#management_company a")
end

Given /^the restaurant has no management data$/ do
  @restaurant.update_attributes(:management_company_website => nil,
      :management_company_name => nil)
end

Then /^I do not see management data$/ do
  response.should_not have_selector("#management_company")
end

Given /^the restaurant has no Twitter of Facebook info$/ do
  @restaurant.update_attributes(:twitter_username => nil, :facebook_page => nil)
end

Then /^I do not see the Twitter username$/ do
  response.should_not have_selector("#twitter_username")
end

Then /^I do not see the Facebook username$/ do
  response.should_not have_selector("#facebook_page")
end

Then /^I see the following restaurant fields:$/ do |fields|
  fields.rows_hash.each do |field, name|
    if name.match(/^http/)
      response.should have_selector("a", :href => name)
    else
      response.should have_selector("#restaurant_profile_view", :content => name)
    end
  end
end

Given /^the following restaurant features:$/ do |features|
  features.hashes.each do |feature_hash|
    page = RestaurantFeaturePage.find_or_create_by_name(feature_hash["page"])
    category = RestaurantFeatureCategory.find_or_create_by_name(feature_hash["category"])
    category.update_attributes(:restaurant_feature_page => page)
    RestaurantFeature.create!(:restaurant_feature_category => category,
        :value => feature_hash["value"])
  end
end

Then /^I see the page headers$/ do
  RestaurantFeaturePage.all.each do |page|
     response.should have_selector(".feature_page", :content => page.name)
  end
end

Then /^I see the page header for "([^\"]*)"$/ do |page_name|
  selected_page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeaturePage.all.each do |page|
    if page == selected_page
      response.should have_selector("#restaurant_features", :content => page.name)
    else
      response.should_not have_selector("#restaurant_features", :content => page.name)
    end
  end
end

Then /^I see the category headers$/ do
  RestaurantFeatureCategory.all.each do |category|
     response.should have_selector(".feature_category", :content => category.name)
  end
end

Then /^I see the category values$/ do
  RestaurantFeature.all.each do |feature|
    response.should have_selector(".feature_category ##{dom_id(feature)}")
  end
end

Then /^I see the category headers for "([^\"]*)"$/ do |page_name|
  selected_page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeatureCategory.all.each do |category|
    if category.restaurant_feature_page == selected_page
      response.should have_selector(".feature_category_header", :content => category.name)
    else
      response.should_not have_selector(".feature_category_header", :content => category.name)
    end
  end
end

Then /^I see the category values for "([^\"]*)"$/ do |page_name|
  selected_page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeature.all.each do |feature|
    if feature.restaurant_feature_page == selected_page
      response.should have_selector(".feature #check_#{dom_id(feature)}")
    else
      response.should_not have_selector(".feature #check_#{dom_id(feature)}")
    end
  end
end

Then /^I see a tag named "([^\"]*)" in the category "([^\"]*)"$/ do |feature, category_name|
  category = RestaurantFeatureCategory.find_by_name(category_name)
  response.should have_selector("##{dom_id(category)} .feature", :content => feature)
end

Then /^I see a category named "([^\"]*)" in the page "([^\"]*)"$/ do |category, page_name|
  page = RestaurantFeaturePage.find_by_name(page_name)
  response.should have_selector("##{dom_id(page)} .feature_category", :content => category)
end

When /^I see a page named "([^\"]*)"$/ do |page|
  response.should have_selector(".feature_page", :content => page)
end

Then /^I see the restaurant's website$/ do
  response.should have_selector("#website", :content => @restaurant.website)
end

Then /^I see headers for feature categories for "([^\"]*)"$/ do |page_name|
  page = RestaurantFeaturePage.find_by_name(page_name)
  @restaurant.categories_for_page(page).each do |category|
    response.should have_selector(".restaurant_feature_category h3", :content => category.name)
  end
  missing = page.restaurant_feature_categories - @restaurant.categories_for_page(page)
  missing.each do |category|
    response.should_not have_selector(".restaurant_feature_category h3", :content => category.name)
  end
end

Then /^I see "([^\"]*)" links for "([^\"]*)"$/ do |category_name, tags|
  category = RestaurantFeatureCategory.find_by_name(category_name)
  tags.split(",").each do |tag|
    response.should have_selector("##{dom_id(category)}", :content => tag.strip)
  end
end

Then /^I do not see links for "([^\"]*)"$/ do |tag|
  response.should_not have_selector(".feature", :content => tag.strip)
end

When /^I see the primary photo$/ do
  response.should have_selector("#primary_photo img")
  response.body.should include("bourgeoispig.jpg")
end

When /^I browse to the the primary photo detail view$/ do
  @restaurant.reload
  click_link_within("#primary_photo", "a")
end

Then /^I should see the primary photo detail view$/ do
  response.should have_selector("#photo_#{@restaurant.reload.primary_photo.id} img")
  response.body.should include("bourgeoispig.jpg")
end

Then /^I should see the restaurant photo gallery$/ do
  @restaurant.reload.photos.each do |photo|
    response.should have_selector("#photo_#{photo.id} img")
    response.body.should include("#{photo.attachment_file_name}")
    response.body.should include(photo.credit)
  end
end

Then /^I should see no restaurant photos$/ do
  response.should have_selector("#no_photos_available")
end

Given /^"([^\"]*)" is tagged with "([^\"]*)"$/ do |restaurant_name, tags|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.restaurant_features << tags.split(",").map { |tag| RestaurantFeature.find_by_value(tag.strip) }
end

Then /^I see the restaurant "([^\"]*)"$/ do |restaurant_name|
  response.should have_selector(".restaurant", :content => restaurant_name)
end

Then /^I see the restaurant logo for the profile$/ do
  response.should have_selector("#restaurant_header img")
  response.body.should include("bourgeoispig_logo.gif")
end

Then /^I see the restaurant menus$/ do
  response.should have_selector(".menus")

  @restaurant.menus.each do |menu|
    response.should have_selector(".menu_item", :content => menu.name)
    response.should have_selector(".menu_item", :content => menu.updated_at.strftime("%m/%d/%Y"))
  end
end

Then /^I should not see any photos$/ do
  response.should_not have_selector("#primary_photo img")
end

Given /^a restaurant feature page named "([^\"]*)"$/ do |name|
  RestaurantFeaturePage.create(:name => name)
end

Then /^I see a delete link for the page "([^\"]*)"$/ do |name|
  page = RestaurantFeaturePage.find_by_name(name)
  response.body.should have_selector("##{dom_id(page)} ##{dom_id(page, :delete_link)}")
end

Then /^I do not see a delete link for the page "([^\"]*)"$/ do |name|
  page = RestaurantFeaturePage.find_by_name(name)
  response.body.should_not have_selector("##{dom_id(page)} ##{dom_id(page, :delete_link)}")
end

Given /^a restaurant feature category named "([^\"]*)" in the page "([^\"]*)"$/ do |name, page_name|
  page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeatureCategory.create(:name => name, :restaurant_feature_page => page)
end

Then /^I see a delete link for the category "([^\"]*)"$/ do |name|
  category = RestaurantFeatureCategory.find_by_name(name)
  response.body.should have_selector("##{dom_id(category)} ##{dom_id(category, :delete_link)}")
end

Then /^I do not see a delete link for the category "([^\"]*)"$/ do |name|
  category = RestaurantFeatureCategory.find_by_name(name)
  response.body.should_not have_selector("##{dom_id(category)} ##{dom_id(category, :delete_link)}")
end

Given /^the restaurant "([^\"]*)" has the tag "([^\"]*)"$/ do |restaurant_name, tag_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.restaurant_features << RestaurantFeature.find_by_value(tag_name)
end

Then /^I see a delete link for the tag "([^\"]*)"$/ do |value|
  feature = RestaurantFeature.find_by_value(value)
  response.body.should have_selector("##{dom_id(feature, :delete_link)}")
end

Then /^I do not see a delete link for the tag "([^\"]*)"$/ do |value|
  feature = RestaurantFeature.find_by_value(value)
  response.body.should_not have_selector("##{dom_id(feature, :delete_link)}")
end

When /^I click on the delete link for the page "([^\"]*)"$/ do |page_name|
  page = RestaurantFeaturePage.find_by_name(page_name)
  click_link(dom_id(page, :delete_link))
end

Then /^I do not see the page "([^\"]*)"$/ do |page_name|
  RestaurantFeaturePage.find_by_name(page_name).should be_nil
end

When /^I click on the delete link for the category "([^\"]*)"$/ do |category_name|
  category = RestaurantFeatureCategory.find_by_name(category_name)
  click_link(dom_id(category, :delete_link))
end

Then /^I do not see the category "([^\"]*)"$/ do |category_name|
  RestaurantFeatureCategory.find_by_name(category_name).should be_nil
end

When /^I click on the delete link for the feature "([^\"]*)"$/ do |feature_value|
  feature = RestaurantFeature.find_by_value(feature_value)
  click_link(dom_id(feature, :delete_link))
end

Then /^I do not see the feature "([^\"]*)"$/ do |feature_value|
  RestaurantFeature.find_by_value(feature_value).should be_nil
end


Then /^I see the ajax button for adding an accolade$/ do
  response.should have_selector(".accolades h2", :content => "Accolades")
end

Then /^I see the opening date$/ do
  response.should have_tag("#opening_date", :content => @restaurant.opening_date.to_s(:long))
end

When /^I add an accolade to the restaurant "([^\"]*)" with:$/ do |restaurant_name, table|
  @restaurant = Restaurant.find_by_name(restaurant_name)
  click_link_within ".accolades", "Add"
  fill_in_fields_for_table(table)
  click_button "Save"
end

Then(/^I should have (\d+) accolades? on my restaurant profile$/) do |num|
  @restaurant.reload.accolades.count.should == num.to_i
end

When /^I should see an accolade for "([^\"]*)" on the profile page for "([^\"]*)"$/ do |accolade_name, restaurant_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  accolade = Accolade.find_by_name(accolade_name)
  visit edit_restaurant_path(restaurant)
  response.should have_selector("#accolades ##{dom_id(accolade)}", :content => accolade_name)
end

Given /^an accolade for "([^\"]*)" named "([^\"]*)"$/ do |restaurant_name, accolade_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  Factory(:accolade, :accoladable => restaurant, :name => accolade_name)
end

Given /^an accolade for "([^\"]*)" named "([^\"]*)" dated "([^\"]*)"$/ do |restaurant_name, accolade_name, date|
  restaurant = Restaurant.find_by_name(restaurant_name)
  Factory(:accolade, :accoladable => restaurant, :name => accolade_name,
      :run_date => Date.parse(date))
end

When /^I click on the "([^\"]*)" link within "([^\"]*)"$/ do |link, accolade_name|
  accolade = Accolade.find_by_name(accolade_name)
  click_link_within("##{dom_id(accolade)}", link)
end

Then /^I should see the accolade form correctly$/ do
  response.should be_success
  response.should have_selector("form.accolade")
end

Then /^"([^\"]*)" should be marked as the primary accolade$/ do |accolade_name|
  accolade = Accolade.find_by_name(accolade_name)
  field_labeled(dom_id(accolade, :primary)).should be_checked
end

Then /^I should see the accolades in order: "([^\"]*)"$/ do |accolade_names|
  expected_names = tableish(".accolade", ".extended-title")
  expected_names.flatten.should == accolade_names.split(",").map(&:strip)
end

Given /^I should see that the restaurant has an overtime account$/ do
  response.should have_selector("#account_type", :content => "cancelled")
end

Given /^a manager for "([^\"]*)" has just uploaded a new menu$/ do |restaurant_name|
  steps %Q{
    Given I am logged in as an account manager for "#{restaurant_name}"
    When I go to the restaurant menu upload page for #{restaurant_name}
    And I fill in "August" for "menu_name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_pdf_remote_attachment_attributes_attachment" on S3
    And I press "Upload"
  }
end
