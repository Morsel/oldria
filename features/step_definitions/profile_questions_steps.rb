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
    Factory(:profile_question, :title => row['title'], :chapter => chapter)
  end
end

Given /^several profile questions matching employment roles for "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  role = Factory(:restaurant_role)
  Factory(:employment, :employee => user, :primary => true, :restaurant_role => role)
  Factory(:profile_question, :title => "Title 1", :restaurant_roles => [role],
      :chapter => Factory(:chapter, :title => "Education"))
  Factory(:profile_question, :title => "Title 2", :restaurant_roles => [role],
      :chapter => Factory(:chapter, :title => "Work Experience"))
  Factory(:profile_question, :title => "Title 3", :restaurant_roles => [role],
      :chapter => Factory(:chapter, :title => "Free Time"))
end

Given /^the following restaurant chapters:$/ do |table|
  table.hashes.each do |row|
    topic = Factory(:topic, :title => row['topic'], :responder_type => 'restaurant')
    Factory(:chapter, :title => row['title'], :topic => topic)
  end
end

Given /^the following (.+) topics:$/ do |responder_type, table|
  table.hashes.each do |row|
    topic = Factory(:topic, :title => row['topic'], :responder_type => responder_type)
  end
end

Given /^I have created the following restaurant profile questions:$/ do |table|
  table.hashes.each do |row|
    question = Factory(:profile_question, :title => row['question'], :chapter => Chapter.find_by_title(row['chapter']))
  end
end

Given /^I have created the following restaurant topics:$/ do |table|
  table.hashes.each do |row|
    topic = Factory(:topic, :title => row['topic'], :responder_type => 'restaurant')
  end
end

