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
  topic = Factory(:topic, :responder_type => 'user')
  Factory(:employment, :employee => user, :primary => true, :restaurant_role => role)
  Factory(:profile_question, :title => "Title 1", :question_roles => [Factory(:question_role, :responder => role)],
      :chapter => Factory(:chapter, :title => "Education", :topic => topic))
  Factory(:profile_question, :title => "Title 2", :question_roles => [Factory(:question_role, :responder => role)],
      :chapter => Factory(:chapter, :title => "Work Experience", :topic => topic))
  Factory(:profile_question, :title => "Title 3", :question_roles => [Factory(:question_role, :responder => role)],
      :chapter => Factory(:chapter, :title => "Free Time", :topic => topic))
end

Given /^profile question matching employment role with static topic name for "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  role = Factory(:restaurant_role)
  topic = Factory(:topic, :title => "SeoTopic", :responder_type => 'user')
  chapter = Factory(:chapter, :title => "Education2", :topic => topic)
  Factory(:employment, :employee => user, :primary => true, :restaurant_role => role)
  Factory(:profile_question,
          :title => "QTitle 1",
          :question_roles => [Factory(:question_role, :responder => role)],
          :chapter => chapter)
end

Given /^the following (.+) profile questions:$/ do |responder_type, table|
  table.hashes.each do |row|
    topic = Topic.find_by_title(row['topic']) || Factory(:topic, :title => row['topic'], :responder_type => responder_type)
    chapter = Chapter.find_by_title(row['chapter']) || Factory(:chapter, :topic => topic, :title => row['chapter'])
    responder = RestaurantFeaturePage.find_by_name(row['page']) || Factory(:restaurant_feature_page, :name => row['page'])
    question = Factory(:profile_question, :title => row['question'], :chapter => chapter, :question_roles => [Factory(:question_role, :responder => responder)])
  end
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

