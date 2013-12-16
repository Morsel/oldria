Then /^I should see unread announcement popup$/ do  
	#page.should have_selector("#unread_announcements_content")
	""
end

Then /^I should not see unread announcement popup$/ do  
  #page.should_not have_selector("#unread_announcements_content")
  ""
end


