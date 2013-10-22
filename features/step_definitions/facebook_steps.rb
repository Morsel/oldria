Given /^Facebook is functioning$/ do
  @message_to_facebook = nil

  status = JSON.parse( File.new( Rails.root + '/spec/fixtures/facebook_response.json').read )
  Mogli::User.stubs(:new).returns(user = mock())
  user.stubs(:feed_create).returns(status)
  
  Mogli::Page.stubs(:new).returns(page = mock())
  page.stubs(:fetch).returns(true)
  page.stubs(:name).returns("My Page")
  page.stubs(:feed_create).returns(@message_to_facebook = status)

  StatusesController.any_instance.stubs(:current_facebook_user).returns(user)
  AdminConversationsController.any_instance.stubs(:current_facebook_user).returns(user)
  Users::BehindTheLineController.any_instance.stubs(:current_facebook_user).returns(user)
  AdminDiscussionsController.any_instance.stubs(:current_facebook_user).returns(user)
end

Then /^message to facebook is sent$/ do
  @message_to_facebook.should_not be_nil
end

Then /^I should see Facebook Share Popup$/ do
  text = "FB.ui"
  page.should have_content(text)
end
