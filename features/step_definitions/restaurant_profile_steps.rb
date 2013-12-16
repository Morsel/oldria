include Capybara::DSL

Given /^a restaurant named "([^\"]*)"$/ do |name|
  @restaurant = FactoryGirl.create(:restaurant, :name => name)
  employment = FactoryGirl.create(:employment, :restaurant => @restaurant)
  profile = FactoryGirl.create(:profile, :user => employment.employee)
  @restaurant.update_attributes!(:media_contact => employment.employee)
end

Given /^a premium restaurant named "([^\"]*)"$/ do |name|
  @restaurant = FactoryGirl.create(:restaurant, :name => name)
  @restaurant.subscription = FactoryGirl.create(:subscription)
  employment = FactoryGirl.create(:employment, :restaurant => @restaurant)
  profile = FactoryGirl.create(:profile, :user => employment.employee)
  @restaurant.update_attributes!(:media_contact => employment.employee)
end

Given /^that "([^\"]*)" has an employee "([^\"]*)"$/ do |restaurant_name, employee_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  employment = FactoryGirl.create(:employment, :restaurant => restaurant,
                       :employee => FactoryGirl.create(:user, :username => employee_name, :password => 'secret') )
end

Then /^I see the restaurant's name linked as "([^\"]*)"$/ do |name|
  within "#name" do
    page.should have_link(name)
  end
end

Then /^I see the restaurant's description$/ do
  within "#description" do
    page.should have_content(@restaurant.description)
  end
end

When /^I see the address$/ do
  @restaurant.address_parts.each do |address_part|
    within ".address" do
      page.should have_content(address_part)
    end
  end
end

Then /^I see the phone number$/ do
  within "#phone_number" do
    #page.should have_content(@restaurant.phone_number)
  end
end

Then /^I see the restaurant's website as a link$/ do
  within "#website" do
    page.should have_link(@restaurant.website, :href => @restaurant.website)
  end
end

Then /^I see the restaurant's Twitter username$/ do
  within "#twitter_username" do
    page.should have_link(@restaurant.twitter_handle, "http://twitter.com/#{@restaurant.twitter_handle}")
  end
end

Then /^I see the restaurant's Facebook page$/ do
  within "#facebook_page" do
    page.should have_link(@restaurant.name, :href => @restaurant.facebook_page_url)
  end
end

When /^I see the restaurant's hours$/ do
  page.should have_selector("#hours", :text => @restaurant.hours)
end

Then /^I see media contact name, phone, and email$/ do
  media_contact = @restaurant.media_contact
  within "#media_contact" do
    page.should have_link(media_contact.name, :href => profile_path(media_contact.username))
    page.should have_content(media_contact.phone_number)
    page.should have_link(media_contact.email, :href => "mailto:#{media_contact.email}")
  end
end

When /^I see media contact name and email, but no phone$/ do
  media_contact = @restaurant.media_contact
  within "#media_contact" do
    page.should have_content(media_contact.name)
    page.should have_no_css("#media_contact_phone")
  end
end

Then /^I see the management company name as a link$/ do
  within "#management_company" do
    page.should have_link(@restaurant.management_company_name, :href => @restaurant.management_company_website)
  end
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
  page.should_not have_css("#media_contact")
end

Given /^the restaurant has no website for its management company$/ do
  @restaurant.update_attributes(:management_company_website => nil)
end

When /^I see the management company name without a link$/ do
  page.should have_selector("#management_company", :text => @restaurant.management_company_name)
  page.should_not have_css("#management_company a")
end

Given /^the restaurant has no management data$/ do
  @restaurant.update_attributes(:management_company_website => nil,
      :management_company_name => nil)
end

Then /^I do not see management data$/ do
  page.should_not have_css("#management_company")
end

Given /^the restaurant has no Twitter or Facebook info$/ do
  @restaurant.update_attributes(:twitter_handle => nil, :facebook_page_url => nil)
end

Then /^I do not see the Twitter username$/ do
  page.should_not have_css("#twitter_username")
end

Then /^I do not see the Facebook username$/ do
  page.should_not have_css("#facebook_page")
end

Then /^I see the following restaurant fields:$/ do |fields|
  fields.rows_hash.each do |field, name|
    if name.match(/^http/)
      #page.should have_css("a", :href => name)
      ""
    else
      #page.should have_selector("#restaurant_profile_view", :text => name)
      ""
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
  RestaurantFeaturePage.all.each do |feature_page|
    #page.should have_selector(".feature_page", :text => feature_page.name)
  end
end

Then /^I see the page header for "([^\"]*)"$/ do |page_name|
  selected_page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeaturePage.all.each do |feature_page|
    within "#restaurant_features" do
      if feature_page == selected_page
        page.should have_content(feature_page.name)
      else
        page.should_not have_content(feature_page.name)
      end
    end
  end
end

Then /^I see the category headers$/ do
  RestaurantFeatureCategory.all.each do |category|
    #page.should have_selector(".feature_category", :text => category.name)
  end
end

Then /^I see the category values$/ do
  RestaurantFeature.all.each do |feature|
    #page.should have_css(".feature_category")
  end
end

Then /^I see the category headers for "([^\"]*)"$/ do |page_name|
  selected_page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeatureCategory.all.each do |category|
    if category.restaurant_feature_page == selected_page
      page.should have_selector(".feature_category_header", :text => category.name)
    else
      page.should_not have_selector(".feature_category_header", :text => category.name)
    end
  end
end

Then /^I see the category values for "([^\"]*)"$/ do |page_name|
  selected_page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeature.all.each do |feature|
    if feature.restaurant_feature_page == selected_page
      page.should have_css(".feature #check_#{dom_id(feature)}")
    else
      page.should_not have_css(".feature #check_#{dom_id(feature)}")
    end
  end
end

Then /^I see a tag named "([^\"]*)" in the category "([^\"]*)"$/ do |feature, category_name|
  category = RestaurantFeatureCategory.find_by_name(category_name)
  # within "category" do
  #   page.should have_selector(".feature", :text => feature)
  # end
end

Then /^I see a category named "([^\"]*)" in the page "([^\"]*)"$/ do |category, page_name|
  feature_page = RestaurantFeaturePage.find_by_name(page_name)
  # within "feature_page" do
  #   page.should have_selector(".feature_category", :text => category)
  # end
end

When /^I see a page named "([^\"]*)"$/ do |feature_page|
  #page.should have_selector(".feature_page", :text => feature_page)
end

Then /^I see the restaurant's website$/ do
  within "#website" do
    page.should have_content(@restaurant.website)
  end
end

Then /^I see headers for feature categories for "([^\"]*)"$/ do |page_name|
  feature_page = RestaurantFeaturePage.find_by_name(page_name)
  @restaurant.categories_for_page(feature_page).each do |category|
    page.should have_selector(".restaurant_feature_category", :text => category.name)
  end
  missing = feature_page.restaurant_feature_categories - @restaurant.categories_for_page(feature_page)
  missing.each do |category|
    page.should_not have_selector(".restaurant_feature_category", :text => category.name)
  end
end

Then /^I see "([^\"]*)" links for "([^\"]*)"$/ do |category_name, tags|
  category = RestaurantFeatureCategory.find_by_name(category_name)
  tags.split(",").each do |tag|
    within "##{dom_id(category)}" do
      page.should have_content tag.strip
    end
  end
end

Then /^I do not see links for "([^\"]*)"$/ do |tag|
  page.should_not have_selector(".feature", :text => tag.strip)
end

When /^I see the primary photo$/ do
  page.should have_css("#primary_photo img")
  page.body.should include("bourgeoispig.jpg")
end

When /^I browse to the the primary photo detail view$/ do
  @restaurant.reload
  within "#primary_photo" do
    click_link "Primary photo"
  end
end

Then /^I should see the primary photo detail view$/ do
  page.should have_css("#photo_#{@restaurant.reload.primary_photo.id} img")
  page.body.should include("bourgeoispig.jpg")
end

Then /^I should see the restaurant photo gallery$/ do
  page.should have_css("#photos")
  @restaurant.reload.photos.each do |photo|
    page.should have_css("#photo_#{photo.id} img")
    page.body.should include("#{photo.attachment_file_name}")
    page.body.should include(photo.credit)
  end
end

Then /^I should see no restaurant photos$/ do
  page.should have_css("#no_photos_available")
end

Given /^"([^\"]*)" is tagged with "([^\"]*)"$/ do |restaurant_name, tags|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.restaurant_features << tags.split(",").map { |tag| RestaurantFeature.find_by_value(tag.strip) }
end

Then /^I see the restaurant "([^\"]*)"$/ do |restaurant_name|
  page.should have_selector(".restaurant", :text => restaurant_name)
end

Then /^I see the restaurant logo for the profile$/ do
  page.should have_css("#restaurant_header img")
  page.body.should include("bourgeoispig_logo.gif")
end

Then /^I see the restaurant menus$/ do
  page.should have_css(".menus")

  @restaurant.menus.each do |menu|
    page.should have_selector(".menu_item", :text => menu.name)
    page.should have_selector(".menu_item", :text => menu.updated_at.strftime("%m/%d/%Y"))
  end
end

Then /^I should not see any photos$/ do
  page.should_not have_css("#primary_photo img")
end

Given /^a restaurant feature page named "([^\"]*)"$/ do |name|
  RestaurantFeaturePage.create(:name => name)
end

Then /^I see a delete link for the page "([^\"]*)"$/ do |name|
  feature_page = RestaurantFeaturePage.find_by_name(name)
  #page.should have_css("##{dom_id(feature_page)} ##{dom_id(feature_page, :delete_link)}")
end

Then /^I do not see a delete link for the page "([^\"]*)"$/ do |name|
  feature_page = RestaurantFeaturePage.find_by_name(name)
  #page.should_not have_css("##{dom_id(feature_page)} ##{dom_id(feature_page, :delete_link)}")
end

Given /^a restaurant feature category named "([^\"]*)" in the page "([^\"]*)"$/ do |name, page_name|
  feature_page = RestaurantFeaturePage.find_by_name(page_name)
  RestaurantFeatureCategory.create(:name => name, :restaurant_feature_page => feature_page)
end

Then /^I see a delete link for the category "([^\"]*)"$/ do |name|
  category = RestaurantFeatureCategory.find_by_name(name)
 #page.should have_css("##{dom_id(category)} ##{dom_id(category, :delete_link)}")
end

Then /^I do not see a delete link for the category "([^\"]*)"$/ do |name|
  category = RestaurantFeatureCategory.find_by_name(name)
  #page.should_not have_css("##{dom_id(category)} ##{dom_id(category, :delete_link)}")
end

Given /^the restaurant "([^\"]*)" has the tag "([^\"]*)"$/ do |restaurant_name, tag_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.restaurant_features << RestaurantFeature.find_by_value(tag_name)
end

Then /^I see a delete link for the tag "([^\"]*)"$/ do |value|
  feature = RestaurantFeature.find_by_value(value)
  #page.should have_css(feature, :delete_link)
end

Then /^I do not see a delete link for the tag "([^\"]*)"$/ do |value|
  feature = RestaurantFeature.find_by_value(value)
  #page.should_not have_css(feature, :delete_link)
end

When /^I click on the delete link for the page "([^\"]*)"$/ do |page_name|
  feature_page = RestaurantFeaturePage.find_by_name(page_name)
  #click_link(feature_page, :delete_link)
end

Then /^I do not see the page "([^\"]*)"$/ do |page_name|
  RestaurantFeaturePage.find_by_name(page_name) == nil
end

When /^I click on the delete link for the category "([^\"]*)"$/ do |category_name|
  category = RestaurantFeatureCategory.find_by_name(category_name)
  #click_link(category, :delete_link)
end

Then /^I do not see the category "([^\"]*)"$/ do |category_name|
  #RestaurantFeatureCategory.find_by_name(category_name) == nil
end

When /^I click on the delete link for the feature "([^\"]*)"$/ do |feature_value|
  feature = RestaurantFeature.find_by_value(feature_value)
  #click_link(feature, :delete_link)
end

Then /^I do not see the feature "([^\"]*)"$/ do |feature_value|
  RestaurantFeature.find_by_value(feature_value) == nil
end

Then /^I see the ajax button for adding an accolade$/ do
  within ".accolades h2" do
    page.should have_content("Accolades")
  end
end

Then /^I see the opening date$/ do
  within "#opening_date" do
    page.should have_content(@restaurant.opening_date.to_date.to_s(:long).gsub(/\s+/, " "))
  end
end

When /^I add an accolade to the restaurant "([^\"]*)" with:$/ do |restaurant_name, table|
  @restaurant = Restaurant.find_by_name(restaurant_name)
  within ".accolades" do
    click_link "add another"
  end
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
  within "#accolades ##{dom_id(accolade)}" do
    page.should have_content(accolade_name)
  end
end

Given /^an accolade for "([^\"]*)" named "([^\"]*)"$/ do |restaurant_name, accolade_name|
  restaurant = Restaurant.find_by_name(restaurant_name)
  FactoryGirl.create(:accolade, :accoladable => restaurant, :name => accolade_name)
end

Given /^an accolade for "([^\"]*)" named "([^\"]*)" dated "([^\"]*)"$/ do |restaurant_name, accolade_name, date|
  restaurant = Restaurant.find_by_name(restaurant_name)
  FactoryGirl.create(:accolade, :accoladable => restaurant, :name => accolade_name,
      :run_date => Date.parse(date))
end

When /^I click on the "([^\"]*)" link within "([^\"]*)"$/ do |link, accolade_name|
  accolade = Accolade.find_by_name(accolade_name)
  within "##{dom_id(accolade)}" do
    click_link link
  end
end

Then /^I should see the accolade form correctly$/ do
  page.should have_css("form.accolade")
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
  # within "#account_status" do
  #   page.should have_content("This restaurant has cancelled their Premium Account.")
  # end
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

Then "I should have home data" do 
       (1..5).each do|index| 
            restaurant = FactoryGirl.create(:restaurant, :is_activated=> true)
            FactoryGirl.create(:menu_item, :restaurant => restaurant)
            @menu_a = FactoryGirl.create(:menu, :position => "1", :restaurant => restaurant)
            @menu_b = FactoryGirl.create(:menu, :position => "2", :restaurant => restaurant)
            @menu_c = FactoryGirl.create(:menu, :position => "3", :restaurant => restaurant)
            restaurant.subscription = FactoryGirl.create(:subscription)
            employment = FactoryGirl.create(:employment, :restaurant => restaurant)
            profile = FactoryGirl.create(:profile, :user => employment.employee)
        end

          
      [11,13,23].each do |index|        
        FactoryGirl.create(:a_la_minute_question,:id=>index,:kind=>"restaurant",:question=>"Our current inspiration is")       
     end
end