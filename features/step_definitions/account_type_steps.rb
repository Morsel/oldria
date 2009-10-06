Given /^there is a "([^\"]*)" account type$/ do |typename|
  AccountType.find_or_create_by_name(typename)
end
