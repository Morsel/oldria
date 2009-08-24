Given /^the following ([\w_]*) records?:?$/ do |factory, table|
  table.hashes.each do |row|
    Factory(factory, row)
  end
end