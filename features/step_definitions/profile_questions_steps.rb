Given /^the following topics:$/ do |table|
  table.hashes.each do |row|
    FactoryGirl.create(:topic, :title => row['title'])
  end
end

Given /^the following chapters:$/ do |table|
  table.hashes.each do |row|
    topic = FactoryGirl.create(:topic, :title => row['topic'])
    FactoryGirl.create(:chapter, :title => row['title'], :topic => topic)
  end
end

Given /^the following questions:$/ do |table|
  table.hashes.each do |row|
    chapter = Chapter.find_by_title(row['chapter']) || FactoryGirl.create(:chapter, :title => row['chapter'])
    FactoryGirl.create(:profile_question, :title => row['title'], :chapter => chapter)
  end
end

Given /^several profile questions matching employment roles for "([^\"]*)"$/ do |username|
  user = User.find_by_username(username)
  role = FactoryGirl.create(:restaurant_role)
  topic = FactoryGirl.create(:topic)
  FactoryGirl.create(:employment, :employee => user, :primary => true, :restaurant_role => role)
  FactoryGirl.create(:profile_question, :title => "Title 1", :question_roles => [FactoryGirl.create(:question_role, :restaurant_role => role)],
      :chapter => FactoryGirl.create(:chapter, :title => "Education", :topic => topic))
  FactoryGirl.create(:profile_question, :title => "Title 2", :question_roles => [FactoryGirl.create(:question_role, :restaurant_role => role)],
      :chapter => FactoryGirl.create(:chapter, :title => "Work Experience", :topic => topic))
  FactoryGirl.create(:profile_question, :title => "Title 3", :question_roles => [FactoryGirl.create(:question_role, :restaurant_role => role)],
      :chapter => FactoryGirl.create(:chapter, :title => "Free Time", :topic => topic))
end

Given /^profile question matching employment role with topic name "([^\"]*)" for "([^\"]*)"$/ do |topic_name, username|
  user = User.find_by_username(username)
  role = FactoryGirl.create(:restaurant_role)
  FactoryGirl.create(:employment, :employee => user, :primary => true, :restaurant_role => role)

  topic = FactoryGirl.create(:topic, :title => topic_name)
  chapter = FactoryGirl.create(:chapter, :title => "Education2", :topic => topic)
  FactoryGirl.create(:profile_question,
          :title => "QTitle 1",
          :question_roles => [FactoryGirl.create(:question_role, :restaurant_role => role)],
          :chapter => chapter)
end

Given /^the following user profile questions:$/ do |table|
  table.hashes.each do |row|
    topic = Topic.find_by_title(row['topic']) || FactoryGirl.create(:topic, :title => row['topic'])
    chapter = Chapter.find_by_title(row['chapter']) || FactoryGirl.create(:chapter, :topic => topic, :title => row['chapter'])
    question = FactoryGirl.create(:profile_question, :title => row['question'], :chapter => chapter, 
        :question_roles => [FactoryGirl.create(:question_role)])
  end
end

Given /^the following restaurant profile questions:$/ do |table|
  table.hashes.each do |row|
    topic = RestaurantTopic.find_by_title(row['topic']) || FactoryGirl.create(:restaurant_topic, :title => row['topic'])
    chapter = Chapter.find_by_title(row['chapter']) || FactoryGirl.create(:chapter, :topic => topic, :title => row['chapter'])
    page = RestaurantFeaturePage.find_by_name(row['page']) || FactoryGirl.create(:restaurant_feature_page, :name => row['page'])
    question = FactoryGirl.create(:restaurant_question, :title => row['question'], :chapter => chapter, 
        :question_pages => [FactoryGirl.create(:question_page, :restaurant_feature_page => page)])
  end
end

Given /^the following restaurant chapters:$/ do |table|
  table.hashes.each do |row|
    topic = FactoryGirl.create(:restaurant_topic, :title => row['topic'])
    FactoryGirl.create(:chapter, :title => row['title'], :topic => topic)
  end
end

Given /^the following user topics:$/ do |table|
  table.hashes.each do |row|
    topic = FactoryGirl.create(:topic, :title => row['topic'])
  end
end

Given /^the following restaurant topics:$/ do |table|
  table.hashes.each do |row|
    topic = FactoryGirl.create(:restaurant_topic, :title => row['topic'])
  end
end

Given /^I have created the following restaurant questions:$/ do |table|
  table.hashes.each do |row|
    question = FactoryGirl.create(:restaurant_question, :title => row['question'], :chapter => Chapter.find_by_title(row['chapter']))
  end
end

Given /^I have created the following restaurant topics:$/ do |table|
  table.hashes.each do |row|
    topic = FactoryGirl.create(:restaurant_topic, :title => row['topic'])
  end
end

When /^I fill in question titled "([^\"]*)" with answer "([^\"]*)"$/ do |title, answer|
  question = ProfileQuestion.find_by_title(title)
  When "I fill in \"profile_question_#{question.id}_answer\" with \"#{answer}\""
end

When /^I fill in the restaurant question titled "([^\"]*)" with answer "([^\"]*)"$/ do |title, answer|
  question = RestaurantQuestion.find_by_title(title)
  When "I fill in \"restaurant_question_#{question.id}_answer\" with \"#{answer}\""
end

Given /^the following profile questions with chapters, topics and answers for "([^\"]*)":$/ do |username, table|
  user = User.find_by_username(username)
  role = FactoryGirl.create(:restaurant_role, :name => "UniqueRole", :category => "UniqueCategory")
  FactoryGirl.create(:employment, :employee => user, :primary => true, :restaurant_role => role)
  table.hashes.each do |row|
    topic = Topic.user_topics.find_by_title(row['topic']) || FactoryGirl.create(:topic,
                                                         :title => row['topic'])
    chapter = topic.chapters.first(:conditions => {:title => row['chapter']}) || FactoryGirl.create(:chapter,
                                                                                         :title => row['chapter'],
                                                                                         :topic => topic)
    question = FactoryGirl.create(:profile_question,
                       :title => row['title'],
                       :question_roles => [FactoryGirl.create(:question_role, :restaurant_role => role)],
                       :chapter =>  chapter)
    FactoryGirl.create(:profile_answer,
            :profile_question => question,
            :user => user,
            :answer => row['answer']) unless row['answer'].blank?
  end
end
