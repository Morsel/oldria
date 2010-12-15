Then /^I should see unread announcement popup$/ do   
  html_key = "Announcement"
  if response.respond_to? :should
    response.should contain(html_key)
  else
    assert_contain html_key
  end
end

Then /^I should not see unread announcement popup$/ do  
  if response.respond_to? :should_not
    response.should_not contain("Announcement")
  else
    assert_not_contain("Announcement")
  end
end


