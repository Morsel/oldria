When /^enter the question title "([^\"]*)"$/ do |title|
  fill_in "Title", :with => title
end

Given /^the following topics:$/ do |table|
  table.hashes.each do |row|
    Factory(:topic, :title => row['title'])
  end
end

Given /^the following chapters:$/ do |table|
  table.hashes.each do |row|
    topic = Factory(:topic, :title => row['topic'])
    Factory(:chapter, :title => row['title'], :topic => topic)
  end
end
