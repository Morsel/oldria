Given /^Twitter is functioning$/ do
  tweet = JSON.parse( File.new( Rails.root + '/spec/fixtures/twitter_response.json').read )
  Twitter::Client.any_instance.stubs(:update).returns(tweet)
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

  visit edit_user_profile_path(u)
end

Then /^"([^\"]+)" should have ([\d]+) friend tweets$/ do |username, number|
  User.find_by_username(username).twitter_client.friends_timeline.length.should == number.to_i
end

Then /^the first tweet should have a link$/ do
  page.should have_css('.tweet') do |t|
    t.should have_css('a')
  end
end

Then /^"([^\"]*)" should not have Twitter linked to (?:his|her) account$/ do |username|
  User.find_by_username(username).should_not be_twitter_authorized
end

