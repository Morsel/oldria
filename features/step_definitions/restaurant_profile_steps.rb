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
    category.update_attributes(:page => page)
    RestaurantFeature.create!(:category => category, :value => feature_hash["value"])
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
