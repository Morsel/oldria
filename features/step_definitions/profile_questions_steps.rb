When /^enter the question title "([^\"]*)"$/ do |title|
  fill_in "Title", :with => title
end
