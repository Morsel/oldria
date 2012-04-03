Then /^I should see the media feed layout$/ do
  page.should have_css("body.mediafeed")
end

When /^I create a new mediafeed page with:$/ do |table|
  visit new_admin_mediafeed_page_path
  fill_in_form(table.rows_hash)
  click_button "Save"
end