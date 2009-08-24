Given /^the following ([\w_]*) records?:?$/ do |factory, table|
  table.hashes.each do |row|
    Factory(factory, row)
  end
end

Given /^the current date is "([^\"]*)"$/ do |date|
  Date.stubs(:today).returns(Date.parse(date))
end
