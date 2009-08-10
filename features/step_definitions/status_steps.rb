Given /^"([^\"]*)" has the following status messages:$/ do |username, table|
  table.hashes.each do |row|
    u = User.find_by_username(username)
    Factory(:status, :user => u, :message => row['message'])
  end
end
