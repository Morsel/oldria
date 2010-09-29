Given /^a restaurant named "([^\"]*)"$/ do |name|
  @restaurant = Factory(:managed_restaurant, :name => name)
end

Then /^I see the restaurant's name as "([^\"]*)"$/ do |name|
  response.should have_selector("#name", :content => name)
end

Then /^I see the restaurant's description$/ do
  response.should have_selector("#description", :content => @restaurant.description)
end

When /^I see the address$/ do
  response.should have_selector("#street1", :content => @restaurant.street1)
  response.should have_selector("#street2", :content => @restaurant.street2)
  response.should have_selector("#city", :content => @restaurant.city)
  response.should have_selector("#state", :content => @restaurant.state)
  response.should have_selector("#zip", :content => @restaurant.zip)
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
  response.should have_selector("#facebook_page a", :content => @restaurant.facebook_page,
      :href => @restaurant.facebook_page)
end

When /^I see the restaurant's hours$/ do
  response.should have_selector("#hours", :content => @restaurant.hours)
end

Then /^I see media contact name, phone, and email$/ do
  response.should have_selector("#media_contact_name", :content => @restaurant.media_contact.name)
  response.should have_selector("#media_contact_phone", :content => @restaurant.media_contact.phone_number)
  response.should have_selector("#media_contact_email a", :content => @restaurant.media_contact.email,
      :href => "mailto:#{@restaurant.media_contact.email}")
  response.should have_selector("#media_contact_email", :content => @restaurant.media_contact.email)
end

Then /^I see the management company name as a link$/ do
  response.should have_selector("#management_company a", :content => @restaurant.management_company_name)
end

Given /^the restaurant has no media contact$/ do
  @restaurant.update_attributes(:media_contact => nil)
end

Then /^I should not see media contact info$/ do
  response.should_not have_selector("#media_contact")
end

Given /^the restaurant has no website for it's management company$/ do
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
    response.should have_selector("##{field}", :content => name)
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

When /^I see the primary photo$/ do
  response.should have_selector("#primary_photo img")
  response.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.reload.primary_photo.id}/medium/bourgeoispig.jpg")  
end
Then /^I
see the restaurant's website$/ do
  response.should have_selector("#website", :content => @restaurant.website)
end

When /^I see a page named "([^\"]*)"$/ do |page|
  response.should have_selector(".feature_page", :content => page) 
end

Then /^I see the restaurant logo for the profile$/ do
  response.should have_selector("#logo img")
  response.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.reload.logo.id}/medium/bourgeoispig_logo.gif")

end

When /^I see a page named "([^\"]*)"$/ do |page|
  response.should have_selector(".feature_page", :content => page) 
end
  
Then /^I see headers for feature categories for "([^\"]*)"$/ do |page_name|
  page = RestaurantFeaturePage.find_by_name(page_name)
  @restaurant.categories_for_page(page).each do |category|
    response.should have_selector(".category_header", :content => category.name)
  end
  missing = page.restaurant_feature_categories - @restaurant.categories_for_page(page)
  missing.each do |category|
    response.should_not have_selector(".category_header", :content => category.name)
  end
end

Then /^I see "([^\"]*)" links for "([^\"]*)"$/ do |category_name, tags|
  category = RestaurantFeatureCategory.find_by_name(category_name)
  tags.split(",").each do |tag|
    response.should have_selector("##{dom_id(category)} .feature", :content => tag.strip)
  end
end

Then /^I do not see links for "([^\"]*)"$/ do |tag|
  response.should_not have_selector(".feature", :content => tag.strip)
end

When /^I see the primary photo$/ do
  response.should have_selector("#primary_photo img")
  response.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.reload.primary_photo.id}/medium/bourgeoispig.jpg")  
end

Given /^"([^\"]*)" is tagged with "([^\"]*)"$/ do |restaurant_name, tags|
  restaurant = Restaurant.find_by_name(restaurant_name)
  restaurant.restaurant_features << tags.split(",").map { |tag| RestaurantFeature.find_by_value(tag.strip) }
end

Then /^I see the restaurant "([^\"]*)"$/ do |restaurant_name|
  response.should have_tag(".restaurant", :content => restaurant_name)
end

Then /^I see the restaurant logo for the profile$/ do
  response.should have_selector("#logo img")
  response.body.should include("http://spoonfeed.s3.amazonaws.com/cucumber/images/#{@restaurant.reload.logo.id}/medium/bourgeoispig_logo.gif")
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



