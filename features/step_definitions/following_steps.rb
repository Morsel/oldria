Given /^"([^\"]*)" is following "([^\"]*)"$/ do |follower, friend|
  User.find_by_username(follower).friends << User.find_by_username(friend)
end

Then /^"([^\"]*)" should be following ([0-9]+) users?$/ do |username,num|
  User.find_by_username(username).friends.count.should == num.to_i
end
