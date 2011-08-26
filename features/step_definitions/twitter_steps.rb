Given /^Twitter is functioning$/ do
  tweet = JSON.parse( File.new( RAILS_ROOT + '/spec/fixtures/twitter_response.json').read )
  TwitterOAuth::Client.any_instance.stubs(:update).returns(tweet)
end


Given /^the following confirmed,? twitter\-authorized users?:?$/ do |table|
  table.hashes.each do |row|
    Factory(:twitter_user, row)
  end
end

When /^Twitter authorizes "([^\"]+)"$/ do |username|
  u = User.find_by_username(username)
  u.asecret = "fakesecret"
  u.atoken  = "faketoken"
  u.save.should be_true
  u.twitter_authorized?.should be_true

  visit path_to('the homepage')
end

Then /^"([^\"]+)" should have ([\d]+) friend tweets$/ do |username, number|
  User.find_by_username(username).twitter_client.friends_timeline.length.should == number.to_i
end

Then /^the first tweet should have a link$/ do
  response.body.should have_selector('.tweet') do |t|
    t.should have_selector('a')
  end
end

Then /^"([^\"]*)" should not have Twitter linked to (?:his|her) account$/ do |username|
  User.find_by_username(username).should_not be_twitter_authorized
end

