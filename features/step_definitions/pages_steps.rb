def fill_in_form(page_data)
  page_data.each do |field,value|
    #fill_in field, :with => value
  end
end

When /^I create a new page with:$/ do |table|
  visit new_admin_page_path
  fill_in_form(table.rows_hash)
  #click_button "Save"
end

Then /^there should be a page with slug "([^\"]*)"$/ do |slug|
  #Page.find_by_slug!(slug)
  Page.where(:slug => slug).first

end

Given /^the(?: special)? "([^\"]*)" page exists$/ do |pagename|
  FactoryGirl.create(:page, :slug => pagename)
end

When /^I update the "([^\"]*)" page with:$/ do |pagename, table|
  page = Page.find_by_slug(pagename)
  visit edit_admin_page_path(page)
  fill_in_form(table.rows_hash)
  #click_button "Save"
end
