When /^I create a new page with:$/ do |table|
  page_data = table.rows_hash
  visit new_admin_page_path
  page_data.each do |field,value|
    fill_in field, :with => value
  end
  click_button "Save"
end

Then /^there should be a page with slug "([^\"]*)"$/ do |slug|
  Page.find_by_slug!(slug)
end
