Given /^Facebook is functioning$/ do
  status = JSON.parse( File.new( RAILS_ROOT + '/spec/fixtures/facebook_response.json').read )
  Mogli::User.stubs(:new).returns(user = mock())
  user.stubs(:feed_create).returns(status)
end
