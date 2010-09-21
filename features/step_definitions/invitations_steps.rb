Given /^there are the following invitations:$/ do |table|
  table.hashes.each do |hash|
    Factory(:invitation, hash)
  end
end
