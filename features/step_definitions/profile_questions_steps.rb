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

Given /^the following questions:$/ do |table|
  table.hashes.each do |row|
    chapter = Chapter.find_by_title(row['chapter']) || Factory(:chapter, :title => row['chapter'])
    Factory(:profile_question, :title => row['title'], :chapters => [chapter])
  end
end
