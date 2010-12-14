Then /^I should see the media feed layout$/ do
  response.should have_selector("body.media_feed")
end
