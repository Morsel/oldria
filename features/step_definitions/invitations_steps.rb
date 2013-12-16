Given /^there are the following invitations:$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:invitation, hash)
  end
end
